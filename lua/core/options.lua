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

-- 缩进折叠
vim.opt.foldmethod = "indent"
vim.opt.foldenable = true      -- 开启折叠
vim.opt.foldlevel = 99         -- 打开文件时全部展开
vim.opt.foldlevelstart = 99    -- 新缓冲区默认展开
vim.opt.foldnestmax = 5        -- 最多嵌套 5 层
vim.opt.shiftwidth = 4         -- 缩进宽度（影响折叠层级）

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

-- 将文件末尾的 ~ 符号替换为空格
opt.fillchars = { eob = " " }

-- 将 nvim-data/site 加入 runtimepath（nvim-treesitter 需要）
opt.runtimepath:append(vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath("data"), "site")))

