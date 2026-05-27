-- Catppuccin 主题配置
return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            float = {
                transparent = true,
            },
            show_end_of_buffer = false,
            term_colors = true,
            dim_inactive = {
                enabled = false,
            },
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                telescope = true,
                lsp_trouble = false,
                which_key = false,
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
            },
            custom_highlights = function(colors)
                return {
                    -- 将有差异的行改为偏红色，与选中行形成更好对比
                    DiffChange = { bg = "#3a2a3a" },
                    -- 窗口分割线高亮：透明背景 + 醒目颜色，便于区分窗口
                    WinSeparator = { fg = colors.mauve, bg = "NONE" },
                }
            end,
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
