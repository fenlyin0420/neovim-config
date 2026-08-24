-- Mason LSP 管理器配置
return {
    -- Mason
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    -- Mason LSP 配置桥接
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "clangd",
                    "svelte",
                },
                automatic_installation = true,
            })

            -- 使用 vim.lsp.config (Neovim 0.11+)
            -- 启用语义高亮 (VSCode 级别的 semantic tokens)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.semanticTokens = {
                multilineTokenSupport = true,
                overlappingTokenSupport = true,
                serverCancelSupport = true,
                augmentsSyntaxTokens = true,
            }

            -- 启用 LSP 语义高亮着色
            vim.lsp.semantic_tokens.enable()
            vim.api.nvim_set_hl(0, "@lsp.type.variable", {})
            vim.api.nvim_set_hl(0, "@lsp.type.parameter", {})
            vim.api.nvim_set_hl(0, "@lsp.type.member", {})
            vim.api.nvim_set_hl(0, "@lsp.type.property", {})
            vim.api.nvim_set_hl(0, "@lsp.type.function", {})
            vim.api.nvim_set_hl(0, "@lsp.type.method", {})
            vim.api.nvim_set_hl(0, "@lsp.type.macro", {})
            vim.api.nvim_set_hl(0, "@lsp.type.type", {})
            vim.api.nvim_set_hl(0, "@lsp.type.enumMember", {})
            vim.api.nvim_set_hl(0, "@lsp.type.modifier", {})
            vim.api.nvim_set_hl(0, "@lsp.type.keyword", {})
            vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
            vim.api.nvim_set_hl(0, "@lsp.type.string", {})
            vim.api.nvim_set_hl(0, "@lsp.type.number", {})
            vim.api.nvim_set_hl(0, "@lsp.type.regexp", {})
            vim.api.nvim_set_hl(0, "@lsp.type.operator", {})
            vim.api.nvim_set_hl(0, "@lsp.type.namespace", {})
            vim.api.nvim_set_hl(0, "@lsp.type.typeParameter", {})
            vim.api.nvim_set_hl(0, "@lsp.type.decorator", {})

            -- Lua
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- Python (Pyright) 配置
            vim.lsp.config("pyright", {
                capabilities = capabilities,

                root_dir = function(bufnr)
                    return vim.fs.root(bufnr, {
                        "uv.lock",
                        "pyproject.toml",
                        ".git",
                        ".venv",
                    })
                end,

                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            diagnosticMode = "workspace",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            autoImportCompletions = true,
                            indexing = true,
                        },
                    },
                },
            })

            -- C/C++
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=bundled",
                    "--pch-storage=memory",
                    "--cross-file-rename",
                },
            })

            -- Svelte
            vim.lsp.config("svelte", {
                capabilities = capabilities,
            })

            -- 启用 LSP 服务器
            vim.lsp.enable({ "lua_ls", "pyright", "clangd", "svelte" })

            -- 全局启用 inlay hints (VSCode 风格的参数名/类型提示)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("InlayHints", {}),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                    end
                end,
            })

            -- LSP 快捷键
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.jump({ count = -1 })
                    end, opts)
                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.jump({ count = 1 })
                    end, opts)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                end,
            })
        end,
    },
}
