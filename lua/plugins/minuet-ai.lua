return {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local mc = require("minuet.config")

        -- AI 补全总开关。minuet 每次真正发请求前都会跑一遍 enable_predicates，
        -- 所以这一个变量就能挡住所有自动补全（virtualtext / cmp / blink / lsp / duet）。
        vim.g.minuet_ai_enabled = false

        local function ai_enabled()
            return vim.g.minuet_ai_enabled ~= false
        end

        -- 关掉时顺手清掉已经显示出来的补全。请求可能已经发出、在关闭之后才返回，
        -- 所以隔一会儿再补清两次，把迟到的结果也擦掉。
        local function dismiss_suggestion()
            require("minuet.virtualtext").action.dismiss()
        end

        vim.keymap.set("n", "<leader>ai", function()
            vim.g.minuet_ai_enabled = not ai_enabled()

            if ai_enabled() then
                vim.notify("AI 补全：已开启", vim.log.levels.INFO)
            else
                dismiss_suggestion()
                vim.defer_fn(dismiss_suggestion, 600)
                vim.defer_fn(dismiss_suggestion, 1600)
                vim.notify("AI 补全：已关闭", vim.log.levels.WARN)
            end
        end, { desc = "开关 AI 补全" })

        require("minuet").setup({
            enable_predicates = { ai_enabled },
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

            -- duet 目前没开自动预测，跟着同一个开关，将来打开了也不用改。
            duet = {
                auto_trigger = { enable_predicates = { ai_enabled } },
            },

            provider_options = {
                -- FIM api 毫秒级响应，chat api 慢，根据场景选择。
                openai_fim_compatible = {
                    model = "deepseek-flash",
                    end_point = "https://api.deepseek.com/beta/completions",
                    api_key = 'DEEPSEEK_API_KEY',
                    optional = {
                        max_tokens = 512,
                        temperature = 0.5,
                        stop = { "\n\n\n", "\r\n\r\n\r\n" },
                    },
                },
                openai_compatible = {
                    model = "deepseek-flash",
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
