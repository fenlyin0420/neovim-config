-- Telescope 模糊查找配置
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-tree/nvim-web-devicons", optional = true },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                prompt_prefix = "  ",
                selection_caret = "  ",
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-c>"] = actions.close,
                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,
                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = actions.select_tab,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<PageUp>"] = actions.results_scrolling_up,
                        ["<PageDown>"] = actions.results_scrolling_down,
                        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-l>"] = actions.complete_tag,
                    },
                    n = {
                        ["<esc>"] = actions.close,
                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = actions.select_tab,
                        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["j"] = actions.move_selection_next,
                        ["k"] = actions.move_selection_previous,
                        ["H"] = actions.move_to_top,
                        ["M"] = actions.move_to_middle,
                        ["L"] = actions.move_to_bottom,
                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,
                        ["gg"] = actions.move_to_top,
                        ["G"] = actions.move_to_bottom,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<PageUp>"] = actions.results_scrolling_up,
                        ["<PageDown>"] = actions.results_scrolling_down,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                live_grep = {
                    additional_args = function()
                        return { "--hidden" }
                    end,
                },
            },
            extensions = {},
        })

        -- 快捷键
        local km = vim.keymap
        km.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "查找文件" })
        km.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "全局搜索" })
        km.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "查找缓冲区" })
        km.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "查找帮助" })
        km.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "最近文件" })
    end,
}
