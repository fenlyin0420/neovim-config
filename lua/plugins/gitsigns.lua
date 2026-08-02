return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "│" }, -- 新增行
                change       = { text = "│" }, -- 修改行
                delete       = { text = "▁" }, -- 删除行
                topdelete    = { text = "‾" },
                changedelete = { text = "~" },
                untracked    = { text = "┆" },
            },
            current_line_blame = true, -- 行尾显示 Git 提交信息

            vim.keymap.set("n", "<leader>p", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Git: 预览当前位置 diff" });
            vim.keymap.set("n", "<leader>r", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Git: restore 当前位置" });
        })
    end,
}
