return {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    enable = false,
    config = function()
        local mc = require("minuet.config")
        require("minuet").setup({
            provider = "openai_fim_compatible",
            n_completions = 1,
            throttle = 400,
            request_timeout = 20,

            virtualtext = {
                enable = true,
                auto_trigger_ft = { '*' },
                keymap = {
                    accept = "<A-f>",
                    accept_line = "<A-l>",
                    next = "<A-]>",
                    prev = "<A-[>",
                    dismiss = "<A-e>",
                },
            },

            cmp = { enable = false },
            blink = { enable = false },
            provider_options = {
                -- FIM api 毫秒级响应，chat api 慢，根据场景选择。
                openai_fim_compatible = {
                    model = "deepseek-v4-flash",
                    end_point = "https://api.deepseek.com/beta/completions",
                    api_key = 'DEEPSEEK_API_KEY',
                    optional = {
                        max_tokens = 512,
                        temperature = 0.5,
                        stop = { "\n\n\n", "\r\n\r\n\r\n" },
                    },
                },
                openai_compatible = {
                    model = "deepseek-v4-flash",
                    end_point = "https://api.deepseek.com/chat/completions",
                    api_key = 'DEEPSEEK_API_KEY',
                    system = mc.default_system_prefix_first,
                    chat_input = mc.default_chat_input_prefix_first,
                    few_shots = mc.default_few_shots_prefix_first,
                    thinking = { type = "disabled" },
                    optional = {
                        max_tokens = 1024,
                        top_p = 0.9,
                    },
                },
            },
        })
    end
}
