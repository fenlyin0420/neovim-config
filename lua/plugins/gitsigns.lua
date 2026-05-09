return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "│" }, -- 新增行
                change       = { text = "│" }, -- 修改行
                delete       = { text = "_" }, -- 删除行
                topdelete    = { text = "‾" },
                changedelete = { text = "~" },
                untracked    = { text = "┆" },
            },
            current_line_blame = true, -- 行尾显示 Git 提交信息（可选）
        })
    end,
}
