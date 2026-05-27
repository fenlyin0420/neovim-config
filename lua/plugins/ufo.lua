-- 多行折叠配置
return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    init = function()
        ----------------------------------------------------------------
        -- 基础折叠设置
        ----------------------------------------------------------------
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        ----------------------------------------------------------------
        -- fold column 高亮
        ----------------------------------------------------------------
        vim.api.nvim_set_hl(0, "FoldColumn", {
            bg = "#89b4fa",
            fg = "NONE",
        })

        ----------------------------------------------------------------
        -- 不需要 statuscolumn 的 filetype
        ----------------------------------------------------------------
        local excluded_filetypes = {
            ["neo-tree"] = true,
            ["alpha"] = true,
            ["dashboard"] = true,
            ["snacks_dashboard"] = true,
            ["lazy"] = true,
            ["mason"] = true,
            ["help"] = true,
            ["terminal"] = true,
            ["toggleterm"] = true,
            ["Trouble"] = true,
            ["qf"] = true,
            [""] = true,
        }
        ----------------------------------------------------------------
        -- StatusColumn
        ----------------------------------------------------------------
        local StatusCol = {}

        ----------------------------------------------------------------
        -- 获取 fold icon
        ----------------------------------------------------------------
        local function fold_icon()
            local lnum = vim.v.lnum
            local foldlevel = vim.fn.foldlevel(lnum)
            local prev_foldlevel =
                lnum > 1 and vim.fn.foldlevel(lnum - 1) or 0

            -- 非 fold 起始行
            if foldlevel == 0 or foldlevel <= prev_foldlevel then
                return " "
            end
            -- 已折叠
            if vim.fn.foldclosed(lnum) ~= -1 then
                return ""
            end
            -- 已展开
            return ""
        end

        ----------------------------------------------------------------
        -- statuscolumn 内容
        ----------------------------------------------------------------
        function StatusCol.get()
            return table.concat({
                fold_icon(),
                " ",
                "%s",
                "%=%l ",
            })
        end

        _G.StatusCol = StatusCol

        ----------------------------------------------------------------
        -- 自动应用 statuscolumn
        ----------------------------------------------------------------
        local group =
            vim.api.nvim_create_augroup("UfoStatusColumn", { clear = true })

        vim.api.nvim_create_autocmd({
            "BufWinEnter",
            "WinEnter",
            "FileType",
        }, {
            group = group,
            callback = function(args)
                local ft = vim.bo[args.buf].filetype
                ----------------------------------------------------------------
                -- 特殊窗口
                ----------------------------------------------------------------
                if excluded_filetypes[ft] then
                    vim.wo.statuscolumn = ""
                    vim.wo.foldcolumn = "0"
                    return
                end
                ----------------------------------------------------------------
                -- 正常编辑窗口
                ----------------------------------------------------------------
                vim.wo.foldcolumn = "1"
                vim.wo.statuscolumn = "%!v:lua.StatusCol.get()"
            end,
        })

        ----------------------------------------------------------------
        -- 启动时处理初始缓冲（alpha 等用了 noautocmd 时兜底）
        ----------------------------------------------------------------
        vim.api.nvim_create_autocmd("UIEnter", {
            group = group,
            once = true,
            callback = function()
                local ft = vim.bo.filetype
                if excluded_filetypes[ft] then
                    vim.wo.foldcolumn = "0"
                    vim.wo.statuscolumn = ""
                end
            end,
        })
    end,

    config = function()
        local ufo = require("ufo")
        ----------------------------------------------------------------
        -- 快捷键
        ----------------------------------------------------------------
        vim.keymap.set("n", "zR", ufo.openAllFolds, {
            desc = "打开所有折叠",
        })

        vim.keymap.set("n", "zM", ufo.closeAllFolds, {
            desc = "关闭所有折叠",
        })

        ----------------------------------------------------------------
        -- peek folded lines
        ----------------------------------------------------------------
        vim.keymap.set("n", "zp", function()
            local winid = ufo.peekFoldedLinesUnderCursor()

            if not winid then
                vim.lsp.buf.hover()
            end
        end, {
            desc = "预览折叠内容",
        })

        ----------------------------------------------------------------
        -- 折叠文本样式
        ----------------------------------------------------------------
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" 󰁂 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth =
                    vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText =
                        truncate(chunkText, targetWidth - curWidth)
                    table.insert(newVirtText, {
                        chunkText,
                        chunk[2],
                    })
                    chunkWidth =
                        vim.fn.strdisplaywidth(chunkText)
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix
                            .. (" "):rep(
                                targetWidth
                                    - curWidth
                                    - chunkWidth
                            )
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end

            table.insert(newVirtText, {
                suffix,
                "Comment",
            })
            return newVirtText
        end

        ----------------------------------------------------------------
        -- ufo setup
        ----------------------------------------------------------------
        ufo.setup({
            fold_virt_text_handler = handler,
            ----------------------------------------------------------------
            -- provider
            ----------------------------------------------------------------
            provider_selector = function(_, filetype, _)
                local ftMap = {
                    vim = "indent",
                    git = "",
                }

                return ftMap[filetype]
                    or { "treesitter", "indent" }
            end,

            ----------------------------------------------------------------
            -- 不自动关闭 imports/comments
            ----------------------------------------------------------------
            close_fold_kinds_for_ft = {
                default = {},
            },

            ----------------------------------------------------------------
            -- preview window
            ----------------------------------------------------------------
            preview = {
                win_config = {
                    border = "rounded",
                    winblend = 0,
                },

                mappings = {
                    scrollU = "<C-u>",
                    scrollD = "<C-d>",
                },
            },
        })
    end,
}
