return {
  "pedrosanto90/neo-tree-ssh.nvim",
  dependencies = {
    "nvim-neo-tree/neo-tree.nvim",
    "nvim-telescope/telescope.nvim", -- 远程文件/搜索弹窗
  },
  config = function()
    local ssh = require("neo-tree-ssh")
    -- ========== 1. 配置你的远程服务器列表 ==========
    ssh.setup({
      servers = {
        -- 服务器别名（自定义，后续命令用这个名字）
        dev = {
          host = "192.168.12.222", -- ~/.ssh/config 的别名/IP/域名
          remote_root = "/data/shenjihe/demo/trace/TRACE-Multimodal-TSEncoder", -- 远程代码根目录（必填）
          -- 可选参数
          user = "root",
          port = 22,
          identity_file = "~/.ssh/id_rsa", -- 私钥路径
          exclude = { "node_modules", "target", ".venv" }, -- 忽略扫描目录
        },
        -- 多台服务器可继续加
        server2 = {
          host = "server-alias-in-ssh-config",
          remote_root = "/srv/project",
        }
      }
    })

    -- ========== 2. 向 neo-tree 注册 SSH 数据源 ==========
    require("neo-tree").setup({
      -- sources 必须加上 "neo-tree-ssh.source"
      sources = { "filesystem", "buffers", "git_status", "neo-tree-ssh.source" },
      -- 可选：优化远程 Git 渲染（远程本地执行git，无需改太多）
      source_selector = {
        winbar = true, -- 顶部显示数据源切换标签
      },
    })

    -- ========== 3. 自定义快捷键（可选，推荐） ==========
    vim.keymap.set("n", "<leader>rs", ":NeotreeSshOpen dev<CR>", { desc = "打开远程dev服务器文件树" })
    vim.keymap.set("n", "<leader>rf", ":NeotreeSshFiles dev<CR>", { desc = "Telescope 远程dev文件查找" })
    vim.keymap.set("n", "<leader>rg", ":NeotreeSshGrep dev<CR>", { desc = "远程rg全局搜索" })
  end
}

