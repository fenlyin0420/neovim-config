return {
    "pedrosanto90/neo-tree-ssh.nvim",
    dependencies = {
        "nvim-neo-tree/neo-tree.nvim",
        "nvim-telescope/telescope.nvim", -- 远程文件/搜索弹窗
    },
    config = function()
        -- 注意：不要在插件配置里调用 require("neo-tree").setup()。
        -- neo-tree 的 setup 只是暂存配置，第二次调用会覆盖 lua/plugins/neo-tree.lua 里的完整配置。
        -- SSH 数据源已经在 neo-tree.lua 的 sources 里注册过了。
        local ssh = require("neotree-ssh")
        -- ========== 1. 配置你的远程服务器列表 ==========
        ssh.setup({
            hosts = {
                -- 服务器别名（自定义，后续命令用这个名字）
                dev = {
                    host = "192.168.12.222", -- ~/.ssh/config 的别名/IP/域名
                    remote_root = "/data/shenjihe/demo/trace/TRACE-Multimodal-TSEncoder", -- 远程代码根目录（必填）
                    -- 可选参数
                    user = "root",
                    port = 22,
                    identity_file = "~/.ssh/id_rsa", -- 私钥路径
                    exclude = { "node_modules", "target", ".venv" }, -- 忽略扫描目录
                },
                -- 多台服务器可继续加
                -- server2 = {
                --     host = "server-alias-in-ssh-config",
                --     remote_root = "/srv/project",
                -- },
            }
        })

        -- ========== 2. 自定义快捷键（可选，推荐） ==========
        vim.keymap.set("n", "<leader>rs", ":NeotreeSshOpen dev<CR>", { desc = "打开远程dev服务器文件树" })
        vim.keymap.set("n", "<leader>rf", ":NeotreeSshFiles dev<CR>", { desc = "Telescope 远程dev文件查找" })
        vim.keymap.set("n", "<leader>rg", ":NeotreeSshGrep dev<CR>", { desc = "远程rg全局搜索" })

        -- ========== 3. 远程 Git 状态（修改/暂存/未跟踪等） ==========
        -- 覆盖 neotree-ssh source：通过 SSH 在远端跑 git status，标注到树节点上。
        -- 需要在 SSH 树第一次打开之前调用；若插件结构变化导致补丁失败，SSH 树仍可用。
        local ok, err = pcall(require("core.ssh-git-status").setup)
        if not ok then
            vim.notify("ssh-git-status setup failed: " .. tostring(err), vim.log.levels.WARN)
        end
    end
}
