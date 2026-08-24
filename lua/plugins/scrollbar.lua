-- 滚动条配置
return {
    "petertriho/nvim-scrollbar",
    dependencies = {
        "lewis6991/gitsigns.nvim",
    },
    -- build = "sed -i 's/hunk.added.start + hunk.added.count - hunk.removed.count + 1/hunk.added.start + hunk.added.count - 1/' lua/scrollbar/handlers/gitsigns.lua",
    config = function()
        require("scrollbar").setup({
            show = true,
            show_in_active_only = false,
            set_highlights = true,
            folds = 1000,
            max_lines = false,
            handle = {
                text = " ",
                blend = 0,
                color = "#585b70",
            },
            marks = {
                Cursor = {
                    text = "▁",
                    -- text = "•",
                },
                Search = {
                    text = { "", "" },
                },
                Error = {
                    text = { "", "" },
                },
                Warn = {
                    text = { "", "" },
                },
                Info = {
                    text = { "", "" },
                },
                Hint = {
                    text = { "", "" },
                },
                Misc = {
                    text = { "", "" },
                },
                GitAdd = {
                    text = "│",
                },
                GitChange = {
                    text = "│",
                },
                GitDelete = {
                    text = "▁",
                },
            },
        })

        require("scrollbar.handlers.gitsigns").setup()
    end,
}
