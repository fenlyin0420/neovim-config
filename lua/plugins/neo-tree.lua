-- Neo-tree 文件树配置
return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- 标记被 mutagen 排除同步的文件
        "fenlyin0420/neo-tree-mutagen.nvim",
    },
    config = function()
        local mutagen_enabled = false

        require("neo-tree-mutagen").setup()

        local fs_components = require("neo-tree.sources.filesystem.components")
        local orig_marker = fs_components.mutagen_marker
        fs_components.mutagen_marker = function(config, node, state)
            if not mutagen_enabled then
                return {}
            end
            return orig_marker(config, node, state)
        end

        require("neo-tree").setup({
            close_if_last_window = false,
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            sort_case_insensitive = false,
            default_component_configs = {
                container = {
                    enable_character_fade = true,
                },
                indent = {
                    indent_size = 2,
                    padding = 1,
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                    highlight = "NeoTreeIndentMarker",
                    with_expanders = nil,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_closed       = "",
                    folder_open         = "",
                    folder_empty        = "",
                    folder_empty_open   = "",
                    default             = "",
                    highlight           = "NeoTreeFileIcon",
                    use_filtered_colors = false
                },
                modified = {
                    symbol = "",
                    highlight = "NeoTreeModified",
                },
                name = {
                    trailing_slash = false,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName",
                },
                git_status = {
                    hide_deleted_files = true,
                    symbols = {
                        added     = "✚",
                        modified  = "✹",
                        -- deleted   = "✗",
                        deleted   = "",
                        renamed   = "➜",
                        untracked = "○",
                        ignored   = "⊝",
                        staged    = "✓",
                        unstaged  = "",
                    }
                },
            },
            window = {
                position = "left",
                width = 40,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    ["<2-LeftMouse>"] = "open",
                    ["<cr>"] = "open",
                    ["<esc>"] = "revert_preview",
                    ["P"] = { "toggle_preview", config = { use_float = true } },
                    ["l"] = "focus_preview",
                    ["S"] = "open_split",
                    ["s"] = "open_vsplit",
                    ["t"] = "open_tabnew",
                    ["w"] = "open_with_window_picker",
                    ["z"] = "close_all_nodes",
                    ["a"] = {
                        "add",
                        config = {
                            show_path = "none",
                        },
                    },
                    ["A"] = "add_directory",
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["c"] = "copy",
                    ["m"] = "move",
                    ["q"] = "close_window",
                    ["R"] = "refresh",
                    ["?"] = "show_help",
                    ["<"] = "prev_source",
                    [">"] = "next_source",
                },
            },
            nesting_rules = {},
            filesystem = {
                filtered_items = {
                    visible = false,
                    -- Keep the search root traversable when the project path is hidden
                    -- (e.g. ~/.config); the fallback `find` command otherwise prunes it.
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false,
                    hide_by_name = {
                        ".DS_Store",
                        "thumbs.db",
                    },
                    -- Keep dotfiles filtered in the tree after enabling search
                    -- traversal for hidden project roots.
                    hide_by_pattern = { ".*" },
                    never_show = {},
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                group_empty_dirs = false,
                hijack_netrw_behavior = "open_default",
                use_libuv_file_watcher = false,
                window = {
                    mappings = {
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["H"] = "toggle_hidden",
                        ["/"] = {
                            "fuzzy_finder",
                            config = { keep_filter_on_submit = true },
                        },
                        ["D"] = {
                            "fuzzy_finder_directory",
                            config = { keep_filter_on_submit = true },
                        },
                        ["f"] = "filter_on_submit",
                        ["<c-x>"] = "clear_filter",
                        ["[g"] = "prev_git_modified",
                        ["]g"] = "next_git_modified",
                    },
                },
            },
            buffers = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
                group_empty_dirs = true,
                show_unloaded = true,
                window = {
                    mappings = {
                        ["bd"] = "buffer_delete",
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                    },
                },
            },
            git_status = {
                window = {
                    position = "float",
                    mappings = {
                        ["A"] = "git_add_all",
                        ["gu"] = "git_unstage_file",
                        ["ga"] = "git_add_file",
                        ["gr"] = "git_revert_file",
                        ["gc"] = "git_commit",
                        ["gp"] = "git_push",
                        ["gg"] = "git_commit_and_push",
                    },
                },
            },
            -- 1. 只扫描当前浏览目录，不再全局扫描整个仓库（最大优化）
            git_status_scope_to_path = true,
            -- 2. 拉长Git刷新间隔，不要实时轮询
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            -- Git异步任务参数
            git_status_async = true,
            git_status_async_options = {
                batch_size = 200, -- 分批处理，降低CPU/IO峰值
                batch_delay = 50, -- 批次间隔，释放nvim主线程
                max_lines = 3000, -- 限制最大扫描文件数，超大仓库截断
            },
            -- 3. 延长Git命令超时时间（SSHFS慢，默认400ms直接超时卡死）
            git = {
                timeout = 10000, -- 10秒超时，防止子进程死锁阻塞nvim
                enable = true,
            },
            -- 4. 关闭全量忽略文件扫描（大仓库大量文件会爆炸）
            respect_gitignore = false,
            -- 5. 降低自动刷新频率
            auto_refresh = {
                enabled = true,
                interval = 3000, -- 3秒刷新一次，不要实时刷新
            }
        })

        -- 快捷键
        vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "切换文件树" })
        vim.keymap.set("n", "<leader>g", "<cmd>Neotree git_status<cr>", { desc = "打开git状态栏" })

        -- mutagen 标记开关
        vim.api.nvim_create_user_command("MutagenToggle", function()
            mutagen_enabled = not mutagen_enabled
            vim.notify("Mutagen 标记: " .. (mutagen_enabled and "开启" or "关闭"), vim.log.levels.INFO)
            -- 刷新 neo-tree
            local ok, neotree = pcall(require, "neo-tree")
            if ok and neotree.refresh then
                neotree.refresh()
            end
        end, { desc = "切换 mutagen 标记显示" })
        vim.keymap.set("n", "<leader>m", "<cmd>MutagenToggle<cr>", { desc = "切换mutagen标记显示" })

        -- 关闭 deleted 文件父目录红色高亮
        local group = vim.api.nvim_create_augroup("NeoTreeHideDeleted", { clear = true })
        local function hide_neotree_deleted_highlight()
            vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { link = "Normal" })
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = group,
            callback = hide_neotree_deleted_highlight,
        })
        hide_neotree_deleted_highlight()
    end,
}
