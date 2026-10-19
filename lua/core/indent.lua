-- 按文件类型设置缩进宽度
--
-- 键为 filetype（`:set ft?` 查看），值为该类型要覆盖的缩进选项：
--   tabstop    : 一个 <Tab> 显示的列宽
--   shiftwidth : >> << 和自动缩进使用的空格数
--   softtabstop: 插入模式下按 <Tab> 产生的空白宽度
--   expandtab  : true 用空格，false 保留真实 tab 字符
--
-- 未列出的 filetype 沿用 options.lua 里的全局值（4 空格）。
local defaults = {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
}

local indent_by_ft = {
  -- 前端 / JS 生态
  javascript = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  javascriptreact = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  typescript = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  typescriptreact = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  vue = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  svelte = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  astro = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  json = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  jsonc = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  yaml = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  toml = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  html = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  css = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  scss = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  markdown = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },

  -- 脚本 / 系统语言
  python = { tabstop = 4, shiftwidth = 4, softtabstop = 4 },
  lua = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  sh = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  bash = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  zsh = { tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  go = { tabstop = 4, shiftwidth = 4, softtabstop = 0, expandtab = false },
  rust = { tabstop = 4, shiftwidth = 4, softtabstop = 4 },
  c = { tabstop = 4, shiftwidth = 4, softtabstop = 4 },
  cpp = { tabstop = 4, shiftwidth = 4, softtabstop = 4 },
  java = { tabstop = 4, shiftwidth = 4, softtabstop = 4 },
  make = { tabstop = 4, shiftwidth = 4, softtabstop = 0, expandtab = false },
}

local function apply(buf, ft)
  local conf = indent_by_ft[ft]
  if not conf then
    return
  end
  for name, value in pairs(vim.tbl_extend("force", defaults, conf)) do
    vim.api.nvim_set_option_value(name, value, { buf = buf, scope = "local" })
  end
end

-- 打开/切换文件类型时生效。注册在 `filetype indent on` 之后，可覆盖 ftplugin 自带的缩进设置。
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("IndentByFiletype", { clear = true }),
  callback = function(args)
    apply(args.buf, args.match)
  end,
})

-- 重新加载配置时，让已打开的缓冲区也立即生效
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    apply(buf, vim.bo[buf].filetype)
  end
end
