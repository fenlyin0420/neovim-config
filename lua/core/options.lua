-- 基础选项配置
local opt = vim.opt

-- 行号
opt.number = true
opt.relativenumber = true

-- 缩进
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true

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

-- 窗口分割线（box drawing 字符，配合 WinSeparator 高亮区分不同窗口）
opt.fillchars = {
    vert = "│",
    horiz = "─",
    horizup = "┴",
    horizdown = "┬",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
    eob = " ",
}

-- 按文件类型加载缩进规则（配合 autoindent 实现正确缩进）
vim.cmd("filetype indent on")
