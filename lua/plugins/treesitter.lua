-- 语法高亮配置
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
            -- 安装的语言解析器
            ensure_installed = {
                "c",
                "cpp",
                "python",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "json",
                "yaml",
                "toml",
                "bash",
                "regex",
            },
            -- 自动安装缺失的解析器
            auto_install = true,
            -- 启用高亮
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            -- 启用增量选择
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            -- 启用缩进
            indent = {
                enable = true,
            },
        })
    end,
}
