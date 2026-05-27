return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    --@type snacks.Config
    opts = function()
        local function load(mod)
            return require("plugins.snacks." .. mod)
        end

        return {
            words = load("words"),
            dashboard = load("dashboard"),
            image = load("image"),
            notifier = load("notifier"),
        }
    end,
    keys = {

    }
}
