-- Alpha 启动页配置
return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII 艺术字
        dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
        }

        -- 按钮
        dashboard.section.buttons.val = {
            dashboard.button("f", "  查找文件", "<cmd>Telescope find_files<cr>"),
            dashboard.button("e", "  新建文件", "<cmd>ene <BAR> startinsert<cr>"),
            dashboard.button("r", "  最近文件", "<cmd>Telescope oldfiles<cr>"),
            dashboard.button("t", "  查找文本", "<cmd>Telescope live_grep<cr>"),
            dashboard.button("c", "  配置文件", "<cmd>e ~/.config/nvim/init.lua<cr>"),
            dashboard.button("q", "  退出", "<cmd>qa<cr>"),
        }

        -- 页脚
        local function footer()
            local version = vim.version()
            local nvim_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
            return "Neovim " .. nvim_version
        end

        dashboard.section.footer.val = footer()

        -- 布局
        dashboard.opts.opts.noautocmd = true
        alpha.setup(dashboard.opts)
    end,
}
