-- Treesitter 配置
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      require("nvim-treesitter").install({
        -- C/C++
        "c",
        "cpp",
        -- Python
        "python",
        -- Lua / Vim
        "lua",
        "vim",
        "vimdoc",
        "query",
        -- Markdown
        "markdown",
        "markdown_inline",
        -- Data / Config
        "json",
        "json5",
        "yaml",
        "toml",
        "xml",
        -- Shell
        "bash",
        "regex",
        -- Web 前端
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "scss",
        -- SQL
        "sql",
        -- Go / Rust
        "go",
        "gomod",
        "gowork",
        "gosum",
        "rust",
        -- 其他
        "dockerfile",
        "gitignore",
        "gitcommit",
        "git_rebase",
        "diff",
        "graphql",
        "proto",
        "make",
        "cmake",
        "comment",
      })

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Treesitter: 启动高亮 / 缩进 / 修复缺失的 parser 与 queries",
        callback = function()
          local ft = vim.bo.filetype
          if not ft or ft == "" then
            return
          end

          -- filetype → parser 语言名（typescriptreact → tsx、javascriptreact → javascript）
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          -- 高亮：Neovim 内置高亮器；pcall 保护无对应语言/filetype 的 buffer（如 neo-tree）
          pcall(vim.treesitter.start, 0, lang)

          -- 仅当该语言有可用 parser 时启用 TS 缩进（无 parser 时回退默认缩进）
          if pcall(vim.treesitter.get_parser, 0, lang) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          local nvimts = require("nvim-treesitter")
          if not vim.list_contains(nvimts.get_available(), lang) then
            return
          end

          -- get_installed() 是 parser 与 queries 的并集。parser 存在而 queries 缺失时
          -- 会被判为已安装从而永不修复，高亮静默失效；故两者分别检查，force 重装。
          local config = require("nvim-treesitter.config")
          local has_parser = vim.list_contains(config.get_installed("parsers"), lang)
          local has_queries = vim.list_contains(config.get_installed("queries"), lang)
          if not has_parser or not has_queries then
            nvimts.install({ lang }, { force = true })
          end
        end,
      })
    end,
  },

  -- Treesitter 文本对象（独立插件，自带 textobjects 查询；需手动注册键位）
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local sel = function(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end
      end
      local mv = function(func, query)
        return function()
          require("nvim-treesitter-textobjects.move")[func](query, "textobjects")
        end
      end

      -- 文本对象（对齐旧版 keymaps）
      local pairs_ = {
        { "af", "@function.outer" },
        { "if", "@function.inner" },
        { "ac", "@class.outer" },
        { "ic", "@class.inner" },
        { "aa", "@parameter.outer" },
        { "ia", "@parameter.inner" },
        { "al", "@loop.outer" },
        { "il", "@loop.inner" },
        { "ai", "@conditional.outer" },
        { "ii", "@conditional.inner" },
        { "ab", "@block.outer" },
        { "ib", "@block.inner" },
      }
      for _, p in ipairs(pairs_) do
        vim.keymap.set({ "x", "o" }, p[1], sel(p[2]))
      end

      -- 跳转（函数 / 类）
      vim.keymap.set("n", "]m", mv("goto_next_start", "@function.outer"))
      vim.keymap.set("n", "]]", mv("goto_next_start", "@class.outer"))
      vim.keymap.set("n", "]M", mv("goto_next_end", "@function.outer"))
      vim.keymap.set("n", "][", mv("goto_next_end", "@class.outer"))
      vim.keymap.set("n", "[m", mv("goto_previous_start", "@function.outer"))
      vim.keymap.set("n", "[[", mv("goto_previous_start", "@class.outer"))
      vim.keymap.set("n", "[M", mv("goto_previous_end", "@function.outer"))
      vim.keymap.set("n", "[]", mv("goto_previous_end", "@class.outer"))

      -- 参数互换
      vim.keymap.set("n", "<leader>sn", function()
        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner", "textobjects")
      end)
      vim.keymap.set("n", "<leader>sp", function()
        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner", "textobjects")
      end)
    end,
  },

  -- Sticky context（类似 VSCode sticky scroll）
  -- plugin/ 文件启动时已以默认值 setup()，这里通过 module 显式指定让 opts 生效
  {
    "nvim-treesitter/nvim-treesitter-context",
    module = "treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 5,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
      zindex = 20,
    },
  },

  -- 更好的代码块注释字符串注入（插件自注册 FileType autocmd，兼容重写版 nvim-treesitter）
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
