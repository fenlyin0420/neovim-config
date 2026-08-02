return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    keys = {
        { '<leader>md', '<cmd>RenderMarkdown buf_toggle<cr>', desc = 'Toggle Markdown Render' },
    },
    config = function()
        local rm = require('render-markdown')

        rm.setup({
            enabled = true,
            render_modes = true,

            anti_conceal = {
                enabled = true,
                above = 0,
                below = 0,
            },

            -- 关键：不要让 conceallevel 吞掉圆角
            win_options = {
                conceallevel = { rendered = 2 },
                concealcursor = { rendered = '' },
                colorcolumn = { default = '', rendered = '' }, -- 避免冲突
            },

            heading = {
                icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
                width = 'full',
            },

            checkbox = {
                enabled = true,
                unchecked = { icon = '□' },
                checked = { icon = '■' },
            },
            -- 公式渲染，确保安装了外部依赖
            latex = {
                -- Turn on / off latex rendering.
                enabled = true,
                -- Additional modes to render latex.
                render_modes = true,
                -- Executable used to convert latex formula to rendered unicode.
                -- If a list is provided the commands run in order until the first success.
                converter = { 'utftex', 'latex2text' },
                -- Highlight for latex blocks.
                highlight = 'RenderMarkdownMath',
                -- Determines where latex formula is rendered relative to block.
                -- | above  | above latex block                               |
                -- | below  | below latex block                               |
                -- | center | centered with latex block (must be single line) |
                position = 'center',
                -- Number of empty lines above latex blocks.
                top_pad = 0,
                -- Number of empty lines below latex blocks.
                bottom_pad = 0,
            },
            -- 代码块：整行 + 圆角 + 柔和的 surface0 背景
            code = {
                enabled = true,
                style = 'full',
                border = 'thin',
                width = 'full',
                left_pad = 2,
                right_pad = 2,
                disable_background = false,

                highlight = 'RenderMarkdownCode',
                highlight_border = 'RenderMarkdownCodeBorder',
                highlight_info = 'RenderMarkdownCodeInfo',
            },

        })

        -- 覆盖代码块背景：surface0 (#313244)，比 mantle 更柔和
        -- 边框线用 overlay0 (#585b70)，背景与代码块一致
        local function set_code_highlights()
            vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#313244' })
            vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', { fg = '#585b70', bg = '#313244' })
        end

        set_code_highlights()

        -- Catppuccin 的 ColorScheme autocmd 会重置高亮，重新覆盖
        vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = '*',
            callback = set_code_highlights,
        })
    end,
}
