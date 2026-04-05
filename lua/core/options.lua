-- 基础选项配置
local opt = vim.opt

-- 行号
opt.number = true
opt.relativenumber = true

-- 缩进
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- 显示
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- 搜索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- 性能
opt.updatetime = 300
opt.timeoutlen = 500

-- 其他
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.mouse = "a"
