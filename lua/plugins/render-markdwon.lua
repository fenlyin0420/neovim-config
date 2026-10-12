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
            render_modes = { "n", "v" },
            -- 关闭后 normal/visual 模式下光标所在行也保持渲染；
            -- 插入模式靠 render_modes = { 'n', 'v' } 整体回落成源码
            anti_conceal = {
                enabled = false,
            },
            win_options = {
                conceallevel = { rendered = 2 },
                concealcursor = { rendered = 'nv' },
                colorcolumn = { default = '', rendered = '' },
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
            latex = {
                enabled = true,
                render_modes = { "n", "v" },
                converter = { 'utftex', 'latex2text' },
                highlight = 'RenderMarkdownMath',
                position = 'center',
                top_pad = 0,
                bottom_pad = 0,
            },
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
            -- 表格核心配置
            pipe_table = {
                enabled = true,
                render_modes = { "n", "v" },
                preset = 'round',
                -- trimmed|padded|raw|overlay：整行 virt_text 覆盖重画，不依赖 conceal，
                -- 代价是单元格内的行内高亮（粗体/行内代码/链接）被整行高亮盖掉，且宽表不再折行
                cell = 'trimmed',
            },
        })

        local function set_code_highlights()
            vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#313244' })
            vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', { fg = '#585b70', bg = '#313244' })
        end
        set_code_highlights()
        vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = '*',
            callback = set_code_highlights,
        })
    end,
}

