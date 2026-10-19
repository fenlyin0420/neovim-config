return {
  "OXY2DEV/markview.nvim",
  ft = { "markdown" },
  cmd = { "Markview" },
  keys = {
    { "<leader>mv", "<cmd>Markview toggle<cr>", desc = "Markview 切换渲染" },
    { "<leader>ms", "<cmd>Markview split<cr>", desc = "Markview 分栏预览" },
    { "<leader>mr", "<cmd>Markview reload<cr>", desc = "重载Markview配置" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    preview = {
      modes = { "n", "no", "v" }, -- 插入模式关闭渲染避免闪烁
      icon_provider = "devicons",
      folds = { enable = false },
      -- 必须设置nowrap，wrap会破坏表格与br虚拟行渲染
      wrap = { enable = false },
    },

    -- HTML核心配置：实现<br>真实视觉换行
    html = {
      enable = true,
      tags = {
        br = {
          conceal = true,   -- 隐藏<br>源码
          virt_line = true, -- 关键：启用虚拟换行（仅dev分支有效）
          text = ""         -- 不显示箭头符号，直接空行分隔
        },
        hr = {
          conceal = true,
          text = "────────────────────────────────────"
        }
      }
    },

    -- 表格修复配置（dev分支专属优化）
    tables = {
      enable = true,
      use_virt_lines = true, -- 虚拟行绘制表格边框
      virtual_padding = 1,
      cell_padding = 2,
      min_column_width = 8,
    },

    headings = { enable = true, sign = true, width = "block" },
    code_blocks = { enable = true, sign = true, style = "language" },
    lists = { enable = true },

    -- 实验性功能：开启多行HTML渲染（br换行依赖此项）
    experimental = {
      check_rtp = false,
      inline_highlight = true,
      multiline_html = true, -- 强制开启多行HTML解析
    },
  },
}
