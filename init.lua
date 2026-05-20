-- ============================================
-- Neovim 配置文件 - 模块化版本
-- ============================================

-- 加载核心配置
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- 配置引导键
vim.g.mapleader = " "
-- 将文件末尾的 ~ 符号替换为空格
vim.opt.fillchars = { eob = " " }

-- 将 nvim-data/site 加入 runtimepath（nvim-treesitter 需要）
vim.opt.runtimepath:append(vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath("data"), "site")))

-- 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 加载插件
require("lazy").setup("plugins", {
    defaults = {
        lazy = false,
    },
    install = {
        colorscheme = { "catppuccin" },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- WSL 剪贴板
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = true,
  }
end
