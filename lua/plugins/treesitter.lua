-- 语法高亮配置
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()
        local ensure_installed = {
            "c",
            "cpp",
            "python",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "markdown",
            "markdown_inline",
            "json",
            "yaml",
            "toml",
            "html",
            "latex",
            "bash",
            "regex",
            "css",
            "javascript",
            "typescript",
            "svelte",
            "cuda",
        }

        require("nvim-treesitter").install(ensure_installed)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TSAutomaticEngine", { clear = true }),
            pattern = ensure_installed, -- 自动匹配上面列表里所有的语言文件类型
            callback = function(args)
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
                if ok and stats and stats.size > 3 * 1024 * 1024 then
                    return
                end

                -- 自动开启 Treesitter 原生高亮
                vim.treesitter.start(args.buf)

                -- 自动开启基于 Treesitter 的原生表达式缩进
                vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
            end,
        })
    end,
}
