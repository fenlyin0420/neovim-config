-- 语法高亮配置 (VSCode-level highlighting)
return {
    -- 核心 Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
                ensure_installed = {
                    -- C/C++
                    "c",
                    "cpp",
                    -- Python
                    "python",
                    -- Lua / Vim
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    -- Markdown
                    "markdown",
                    "markdown_inline",
                    -- Data / Config
                    "json",
                    "json5",
                    "yaml",
                    "toml",
                    "xml",
                    -- Shell
                    "bash",
                    "regex",
                    -- Web frontend
                    "javascript",
                    "typescript",
                    "tsx",
                    "html",
                    "css",
                    "scss",
                    -- SQL
                    "sql",
                    -- Go / Rust
                    "go",
                    "gomod",
                    "gowork",
                    "gosum",
                    "rust",
                    -- Misc
                    "dockerfile",
                    "gitignore",
                    "gitcommit",
                    "git_rebase",
                    "diff",
                    "graphql",
                    "proto",
                    "make",
                    "cmake",
                    "comment",
                },
                auto_install = true,

                -- 高亮配置 — VSCode 级别
                highlight = {
                    enable = true,
                    -- 禁用 vim 正则高亮，完全交由 Treesitter
                    additional_vim_regex_highlighting = false,
                },

                -- 增量选择 (用 Treesitter 语法树扩展选择)
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },

                -- 缩进 (基于 Treesitter 语法树)
                indent = {
                    enable = true,
                },

                -- 文本对象 (函数/类/参数级别跳转)
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>sn"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>sp"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
    },

    -- Treesitter 文本对象 (函数/类/参数级别)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Sticky context (类似 VSCode sticky scroll)
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            enable = true,
            max_lines = 5,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = "outer",
            mode = "cursor",
            separator = "─",
            zindex = 20,
        },
    },

    -- 更好的代码块注释字符串注入
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            enable_autocmd = false,
        },
    },
}
