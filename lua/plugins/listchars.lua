return {
    "0xfraso/nvim-listchars",
    opts = {
        listchars = {
            tab = "> ",
            trail = ".",    -- 行尾多余的空格
            space = "·",
            nbsp = "␣",    -- 非断行空格（non-breaking space）
            eol = "↲",
        },
        exclude_filetypes = { "alpha", "dashboard", "NvimTree" },
    },
    keys = {
        { "<leader>ws", "<cmd>ListcharsToggle<cr>", desc = "Toggle whitespace" },
    },
}
