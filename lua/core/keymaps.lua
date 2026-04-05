-- 快捷键配置
local km = vim.keymap
local opts = { noremap = true, silent = true }

-- 清空搜索高亮
km.set("n", "<ESC>", ":nohl<CR>", opts)

-- 快速保存
km.set("n", "<C-s>", ":w<CR>", opts)

-- 复制粘贴
-- 【复制】
-- 可视模式：选中后按 Ctrl+c 复制到系统剪贴板
km.set("v", "<C-c>", '"+y', opts)
-- 普通模式：按 Ctrl+c 复制当前行到系统剪贴板
km.set("n", "<C-c>", '"+yy', opts)

-- 【粘贴】
-- 普通模式：按 Ctrl+v 粘贴系统剪贴板内容
km.set("n", "<C-v>", '"+p', opts)
-- 插入模式：按 Ctrl+v 粘贴（通过 <C-r>+ 实现，这样不会破坏撤销记录）
km.set("i", "<C-v>", "<C-r>+", opts)
-- 可视模式：粘贴并覆盖选区（不将覆盖的内容存入寄存器，防止连续粘贴出错）
km.set("v", "<C-v>", '"_dP', opts)

-- 【全选】
-- 顺便帮你配一个 Ctrl+a 全选，配合复制更方便
km.set("n", "<C-a>", "ggVG", opts)

-- 注释快捷键 (使用 Comment.nvim)
km.set("n", "<C-/>", "gcc", { remap = true, silent = true })
km.set("v", "<C-/>", "gc", { remap = true, silent = true })
km.set("n", "<leader>/", "gcc", { remap = true, desc = "单行注释" })
km.set("v", "<leader>/", "gc", { remap = true, desc = "选中注释" })

-- 窗口导航
km.set("n", "<C-h>", "<C-w>h", opts)
km.set("n", "<C-j>", "<C-w>j", opts)
km.set("n", "<C-k>", "<C-w>k", opts)
km.set("n", "<C-l>", "<C-w>l", opts)

-- 调整窗口大小
km.set("n", "<C-Up>", ":resize -2<CR>", opts)
km.set("n", "<C-Down>", ":resize +2<CR>", opts)
km.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
km.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- 缓冲区间导航
km.set("n", "<S-l>", ":bnext<CR>", opts)
km.set("n", "<S-h>", ":bprevious<CR>", opts)
km.set("n", "<leader>bd", ":bdelete<CR>", { desc = "关闭缓冲区" })

-- 更好的缩进体验
km.set("v", "<S-Tab>", "<gv", opts)
km.set("v", "<Tab>", ">gv", opts)

-- 移动选中文本
km.set("v", "J", ":m '>+1<CR>gv=gv", opts)
km.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- 取消 Q 进入 Ex 模式
km.set("n", "Q", "<nop>", opts)
