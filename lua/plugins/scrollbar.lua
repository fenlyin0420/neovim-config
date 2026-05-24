return {
    "petertriho/nvim-scrollbar",
    dependencies = {
        "lewis6991/gitsigns.nvim",
    },

    config = function()
        require("scrollbar").setup({
            show = true,
            show_in_active_only = false,
            set_highlights = true,
            folds = 1000,
            max_lines = false,
            handle = {
                text = " ",
                blend = 30,
            },
            marks = {
                Cursor = {
                    text = "•",
                },
                Search = {
                    text = { "-", "=" },
                },
                Error = {
                    text = { "-", "=" },
                },
                Warn = {
                    text = { "-", "=" },
                },
                Info = {
                    text = { "-", "=" },
                },
                Hint = {
                    text = { "-", "=" },
                },
                Misc = {
                    text = { "-", "=" },
                },
                GitAdd = {
                    text = "┆",
                },
                GitChange = {
                    text = "┆",
                },
                GitDelete = {
                    text = "▁",
                },
            },
        })

        require("scrollbar.handlers.gitsigns").setup()
    end,
}
