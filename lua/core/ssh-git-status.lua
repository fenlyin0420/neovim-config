-- neotree-ssh 远程 Git 状态
--
-- neotree-ssh 用 `ssh:/host/path` 这种虚拟路径浏览/编辑远程文件，而 neo-tree 内置的
-- git 集成是在本地执行 `git -C <path> ...`，对 ssh: 路径必然拿不到任何信息，
-- 所以远程仓库里看不到 修改/暂存/未跟踪 等状态。
--
-- 本模块在配置侧给 neotree-ssh 的 source 打补丁（不修改插件源码，升级插件不受影响）：
--   1. 通过插件复用的 ControlMaster 连接在远端执行 `git status --porcelain -z`，
--      结果按 host 缓存（TTL + 远程文件写盘后失效），在 _build_dir 构建目录时
--      标注到每个节点上。
--   2. 覆盖 source 的 git_status 组件，直接读 node.extra.git_status 渲染符号/高亮，
--      与本地 neo-tree 的表现保持一致（修改/暂存/删除/重命名/未跟踪/冲突）。
--
-- 必须在 SSH 树第一次打开之前调用一次 setup()；在 lua/plugins/neo-tree-ssh.lua
-- 的 config 里调用即可（neo-tree 在 create_state 时才 deepcopy 各 source 的
-- components，所以此时打补丁仍会被新打开的 SSH 树捕获到）。
--
-- 可选的 host 配置项：在 hosts.<name> 里加 `disable_git_status = true` 关闭该 host
-- 的 git 状态。

local highlights = require("neo-tree.ui.highlights")

local M = {}

-- host_name -> { toplevel = string?, lookup = { [repo_relative] = code }, fetched_at = number }
local host_info = {}
local TTL = 5 -- 秒

local function shellquote(s)
  return "'" .. (s:gsub("'", [['\'']])) .. "'"
end

---把 porcelain 状态码规范成 neo-tree parser 用的格式
---（` M` -> `.M`，`??` -> `?`，`!!` -> `!`）
local function normalize_code(code)
  if code == "??" then return "?" end
  if code == "!!" then return "!" end
  return code:gsub(" ", ".")
end

---解析 `git status --porcelain -z` 输出为 { [repo_relative_path] = status_code }
---注意：git status 输出的路径相对于仓库 toplevel（不是 -C 的目录）。
local function parse_status(stdout)
  local lookup = {}
  local pending
  for field in stdout:gmatch("([^%z]+)") do
    if pending then
      -- rename/copy 的第二段是新的路径名
      lookup[field] = pending
      pending = nil
    else
      local code, path = field:match("^(..) (.*)$")
      if code and path and path ~= "" then
        if code:find("R") or code:find("C") then
          pending = normalize_code(code)
        else
          lookup[path] = normalize_code(code)
        end
      end
    end
  end
  return lookup
end
M._parse_status = parse_status

---取某个 host 的 git 信息（远端 toplevel + 状态表），带 TTL 缓存
function M.get_git_info(host_name)
  local cached = host_info[host_name]
  if cached and os.time() - cached.fetched_at < TTL then
    return cached
  end

  local source = require("neotree-ssh.source")
  local main = require("neotree-ssh")
  local cfg = main.get_config()
  local host_cfg = cfg.hosts[host_name]
  if not host_cfg or host_cfg.disable_git_status then
    return nil
  end

  local conn, _ = source._get_conn(host_name)
  if not conn then
    return nil
  end

  local root = host_cfg.remote_root
  if not root or root == "" then
    return nil
  end

  local info = { toplevel = nil, lookup = {}, fetched_at = os.time() }

  local r = conn:exec("git -C " .. shellquote(root) .. " rev-parse --show-toplevel 2>/dev/null")
  if r.code == 0 and r.stdout ~= "" then
    info.toplevel = (r.stdout:match("^([^\n\r]+)") or ""):gsub("/$", "")
  end

  if info.toplevel then
    r = conn:exec(
      "git -C " .. shellquote(root) .. " status --porcelain -z --untracked-files=all 2>/dev/null"
    )
    if r.code == 0 then
      info.lookup = parse_status(r.stdout)
    end
  end

  host_info[host_name] = info
  return info
end

function M.invalidate(host_name)
  if host_name then
    host_info[host_name] = nil
  else
    host_info = {}
  end
end

---把 git 状态标到一批节点上（节点路径按 toplevel 前缀映射成仓库相对路径）
local function annotate_children(root, info)
  if not root or not info or not info.toplevel or not root.children then
    return
  end
  local base = info.toplevel
  for _, child in ipairs(root.children) do
    local remote = child.extra and child.extra.remote_path
    if remote and remote:sub(1, #base) == base then
      local rel = remote:sub(#base + 1):gsub("^/", "")
      local code = info.lookup[rel]
      if code then
        child.extra.git_status = code
      end
    end
  end
end
M._annotate_children = annotate_children

local to2char = function(symbol)
  if vim.fn.strchars(symbol) == 1 then
    return symbol .. " "
  else
    return symbol
  end
end

local function default_symbols()
  local cfg = require("neo-tree").config
  local gs = cfg and cfg.default_component_configs and cfg.default_component_configs.git_status
  return (gs and gs.symbols) or {}
end

---覆盖 neotree-ssh source 的 git_status 组件：直接读 node.extra.git_status。
---逻辑与 neo-tree 内置的 common.git_status 保持一致（符号 + 高亮 + use_git_status_colors）。
function M.git_status(config, node, state)
  local node_is_dir = node.type == "directory"
  if node.type == "message" then
    return {}
  end
  if node_is_dir and config.hide_when_expanded and node:is_expanded() then
    return {}
  end

  local status = node.extra and node.extra.git_status
  if not status then
    return {}
  end
  if type(status) == "table" then
    status = status[1]
  end

  local symbols = config.symbols or default_symbols()

  local stage_sb, stage_hl
  local staged_change_sb, staged_change_hl
  local worktree_change_sb, worktree_change_hl

  -- 未跟踪 / 忽略
  if status == "?" then
    stage_sb = symbols.untracked
    stage_hl = highlights.GIT_UNTRACKED
    return { text = to2char(stage_sb), highlight = stage_hl }
  end
  if status == "!" then
    stage_sb = symbols.ignored
    stage_hl = highlights.GIT_IGNORED
    return { text = to2char(stage_sb), highlight = stage_hl }
  end

  local x, y = status:sub(1, 1), status:sub(2, 2)
  local is_conflict = false
  if y == "." then
    stage_sb = symbols.staged
    stage_hl = highlights.GIT_STAGED
  elseif x == "." then
    stage_sb = symbols.unstaged
    stage_hl = highlights.GIT_UNSTAGED
  else
    local parser = require("neo-tree.git.parser")
    if parser.status_code_is_conflict(x, y) then
      is_conflict = true
      stage_sb = symbols.conflict
      stage_hl = highlights.GIT_CONFLICT
    end
  end

  if #x > 0 and x ~= "." then
    if x == "M" or x == "U" then
      staged_change_sb = symbols.modified
      staged_change_hl = highlights.GIT_MODIFIED
    elseif x == "R" then
      staged_change_sb = symbols.renamed
      staged_change_hl = highlights.GIT_RENAMED
    elseif x == "D" then
      staged_change_sb = symbols.deleted
      staged_change_hl = highlights.GIT_DELETED
    else
      staged_change_sb = symbols.added
      staged_change_hl = highlights.GIT_ADDED
    end
  end

  if not is_conflict and #y > 0 and y ~= "." then
    if y == "M" or y == "U" then
      worktree_change_sb = symbols.modified
      worktree_change_hl = highlights.GIT_MODIFIED
    elseif y == "R" then
      worktree_change_sb = symbols.renamed
      worktree_change_hl = highlights.GIT_RENAMED
    elseif y == "D" then
      worktree_change_sb = symbols.deleted
      worktree_change_hl = highlights.GIT_DELETED
    else
      worktree_change_sb = symbols.added
      worktree_change_hl = highlights.GIT_ADDED
    end
  end

  if not staged_change_sb and not worktree_change_sb then
    return {
      text = "[" .. status .. "]",
      highlight = config.highlight or worktree_change_hl or staged_change_hl,
    }
  end

  local components = {}
  if staged_change_sb and #staged_change_sb > 0 then
    components[#components + 1] = { text = to2char(staged_change_sb), highlight = staged_change_hl }
  end
  if worktree_change_sb and #worktree_change_sb > 0 then
    components[#components + 1] = { text = to2char(worktree_change_sb), highlight = worktree_change_hl }
  end
  local display_stage_sb = #components < 2 or is_conflict
  if display_stage_sb and stage_sb and #stage_sb > 0 then
    components[#components + 1] = { text = to2char(stage_sb), highlight = stage_hl }
  end
  return components
end

---给 neotree-ssh 的 source 打补丁。在 SSH 树第一次打开前调用一次即可（幂等）。
function M.setup()
  local source = require("neotree-ssh.source")
  if source._ssh_git_patched then
    return
  end
  source._ssh_git_patched = true

  -- 覆盖 git_status 组件（组件表由 neo-tree 在 create_state 时 deepcopy，补丁能生效）
  local components = require("neotree-ssh.source.components")
  components.git_status = M.git_status

  -- 构建目录时标注 git 状态
  local orig_build_dir = source._build_dir
  source._build_dir = function(host_name, remote_path)
    local root, count, err = orig_build_dir(host_name, remote_path)
    if root and not err then
      annotate_children(root, M.get_git_info(host_name))
    end
    return root, count, err
  end

  -- 远程文件写盘后失效该 host 的 git 缓存（最常见的改动来源）。
  -- 注意：插件把缓冲区设为 buftype=acwrite，这种缓冲区的 :w 只触发 BufWriteCmd，
  -- BufWritePost 不会触发。插件自己的 BufWriteCmd 定义更早、先执行，写完后
  -- 才会轮到这里的 handler，所以在这里失效缓存是准确的。
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    pattern = "ssh:/*",
    callback = function(args)
      M.invalidate(source.parse_url(args.match))
    end,
  })
end

return M
