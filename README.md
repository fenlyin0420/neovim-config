# Neovim Configuration

基于 [lazy.nvim](https://github.com/folke/lazy.nvim) 的模块化 Neovim 配置，面向日常开发，提供开箱即用的 IDE 体验。

## 功能概览

- **启动页** — 美观的 Alpha 启动页，快速访问文件搜索、最近文件等
- **文件树** — Neo-tree 文件浏览器，支持 Git 状态、诊断信息、缓冲区管理
- **模糊搜索** — Telescope 集成，支持文件、文本、缓冲区、帮助标签搜索
- **自动补全** — nvim-cmp + LuaSnip，支持 LSP、代码片段、缓冲区、路径补全
- **LSP 支持** — 集成 Mason，预置 Lua/Python/C/C++ 语言服务器
- **语法高亮** — Tree-sitter，支持多种语言的高亮、增量选择、智能缩进
- **状态栏** — Lualine 显示模式、Git 分支、差异、诊断、文件路径等信息
- **Git 集成** — Gitsigns 行内标记，Neo-tree Git 状态面板
- **注释工具** — Comment.nvim，支持 Tree-sitter 上下文感知注释
- **终端** — Toggleterm 浮动终端，支持缓冲区导航
- **自动配对** — nvim-autopairs，自动补全括号/引号，支持 HTML/XML 标签
- **缩进线** — indent-blankline 缩进参考线
- **透明背景** — 主题支持透明背景，适配终端模拟器

## 快捷键

> `<leader>` 键为空格键 `<Space>`。

### 通用

| 快捷键 | 功能 |
|--------|------|
| `<Esc>` | 取消搜索高亮 |
| `<C-s>` | 保存文件 |
| `<C-a>` | 全选 |
| `Q` | 禁用 Ex 模式（防止误触） |

### 复制粘贴（系统剪贴板）

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-c>` | 普通模式 | 复制当前行到系统剪贴板 |
| `<C-c>` | 可视模式 | 复制选中内容到系统剪贴板 |
| `<C-v>` | 普通模式 | 粘贴系统剪贴板内容 |
| `<C-v>` | 插入模式 | 粘贴系统剪贴板内容 |
| `<C-v>` | 可视模式 | 粘贴并覆盖选区 |

### 缓冲区管理

| 快捷键 | 功能 |
|--------|------|
| `<S-h>` | 上一个缓冲区 |
| `<S-l>` | 下一个缓冲区 |
| `<leader>bd` | 关闭当前缓冲区 |

### 窗口管理

| 快捷键 | 功能 |
|--------|------|
| `<C-Up>` | 窗口高度减 2 |
| `<C-Down>` | 窗口高度加 2 |
| `<C-Left>` | 窗口宽度减 2 |
| `<C-Right>` | 窗口宽度加 2 |

### 可视模式

| 快捷键 | 功能 |
|--------|------|
| `<Tab>` | 增加缩进（保持选中） |
| `<S-Tab>` | 减少缩进（保持选中） |
| `J` | 选中行下移 |
| `K` | 选中行上移 |
| `<C-/>` | 注释/取消注释选中行 |

### 注释

| 快捷键 | 功能 |
|--------|------|
| `<C-/>` | 注释/取消注释当前行 |

> 更多注释操作：`gcc`（行注释）、`gbc`（块注释）、`gc`（行注释操作符）、`gb`（块注释操作符）

### LSP

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gr` | 查找引用 |
| `gi` | 跳转到实现 |
| `K` | 悬停显示文档 |
| `<C-k>` | 显示签名帮助 |
| `<leader>rn` | 重命名 |
| `<leader>ca` | 代码操作 |
| `<leader>f` | 格式化代码 |
| `[d` | 上一个诊断 |
| `]d` | 下一个诊断 |
| `<leader>d` | 显示诊断详情 |

### Telescope 模糊搜索

| 快捷键 | 功能 |
|--------|------|
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全局文本搜索 |
| `<leader>fb` | 查找已打开的缓冲区 |
| `<leader>fh` | 查找帮助标签 |
| `<leader>fr` | 最近打开的文件 |

Telescope 界面内快捷键：

| 快捷键 | 功能 |
|--------|------|
| `<C-j>` / `<C-k>` | 上下移动选择 |
| `<C-n>` / `<C-p>` | 上下浏览搜索历史 |
| `<C-u>` / `<C-d>` | 预览区滚动 |
| `<C-v>` | 垂直分屏打开 |
| `<C-x>` | 水平分屏打开 |
| `<C-t>` | 新标签页打开 |
| `<C-q>` | 发送到快速修复列表 |

### 文件树（Neo-tree）

| 快捷键 | 功能 |
|--------|------|
| `<leader>e` | 切换文件树 |
| `<leader>g` | 打开 Git 状态面板 |

Neo-tree 窗口内快捷键：

| 快捷键 | 功能 |
|--------|------|
| `<cr>` | 打开文件/展开目录 |
| `<bs>` | 返回上级目录 |
| `a` | 新建文件 |
| `A` | 新建目录 |
| `d` | 删除 |
| `r` | 重命名 |
| `c` | 复制 |
| `m` | 移动 |
| `y` / `x` / `p` | 复制/剪切/粘贴 |
| `s` / `S` | 水平/垂直分屏打开 |
| `t` | 新标签页打开 |
| `H` | 切换显示隐藏文件 |
| `R` | 刷新 |
| `?` | 帮助 |
| `[g` | 上一个 Git 修改文件 |
| `]g` | 下一个 Git 修改文件 |

### Git 状态窗口（Neo-tree）

| 快捷键 | 功能 |
|--------|------|
| `A` | 暂存所有修改文件 |
| `gu` | 取消暂存光标所在文件 |
| `ga` | 暂存光标所在文件 |
| `gr` | 撤销文件修改 |
| `gc` | 提交已暂存的更改 |
| `gp` | 推送到远程 |
| `gg` | 提交并推送 |

> 使用 `<leader>g` 打开 Git 状态浮动窗口。

### 终端（Toggleterm）

| 快捷键 | 功能 |
|--------|------|
| `<C-\>` | 切换浮动终端 |
| `<Esc>` | 终端切换到普通模式 |
| `<C-h/j/k/l>` | 终端内切换窗口 |

### 自动补全

| 快捷键 | 功能 |
|--------|------|
| `<C-Space>` | 手动触发补全 |
| `<C-b>` / `<C-f>` | 滚动文档预览 |
| `<C-e>` | 取消补全 |
| `<Tab>` / `<S-Tab>` | 选择下一项/上一项 |
| `<CR>` | 确认选择 |
| `<Tab>` | 展开/跳转代码片段 |

### Tree-sitter 文本选择

| 快捷键 | 功能 |
|--------|------|
| `<C-space>` | 初始化/扩大选中节点 |
| `<bs>` | 缩小选中节点 |

## 插件列表

| 插件 | 用途 |
|------|------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | 插件管理器 |
| [catppuccin](https://github.com/catppuccin/nvim) | 主题（Mocha 风味，透明背景） |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | 启动页 |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | 文件浏览器 |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | 模糊查找 |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 自动补全 |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 代码片段引擎 |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 预置代码片段 |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 客户端配置 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP 服务器安装管理 |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮与解析 |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 行内标记 |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | 注释工具 |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | 浮动终端 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自动配对括号/引号 |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | 缩进参考线 |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | 文件图标 |

## 目录结构

```
~/.config/nvim/
├── init.lua              # 入口文件
├── lua/
│   ├── core/
│   │   ├── options.lua   # 基础选项
│   │   ├── keymaps.lua   # 快捷键
│   │   └── autocmds.lua  # 自动命令
│   └── plugins/
│       ├── alpha.lua              # 启动页
│       ├── autopairs.lua          # 自动配对
│       ├── catppuccin.lua         # 主题
│       ├── cmp.lua                # 自动补全
│       ├── comment.lua            # 注释
│       ├── gitsigns.lua           # Git 标记
│       ├── indent-blankline.lua   # 缩进线
│       ├── lsp.lua                # LSP
│       ├── lualine.lua            # 状态栏
│       ├── neo-tree.lua           # 文件树
│       ├── telescope.lua          # 模糊搜索
│       ├── toggleterm.lua         # 终端
│       └── treesitter.lua         # 语法高亮
└── README.md
```

## 预置语言服务器

首次启动时自动安装：

- **Lua** — `lua_ls`
- **Python** — `pyright`
- **C/C++** — `clangd`

如需添加更多语言，编辑 `lua/plugins/lsp.lua` 中 `ensure_installed` 列表即可。

## 安装

1. 确保已安装 Neovim 0.10+（推荐 0.11+）
2. 备份已有的配置：
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```
3. 克隆配置：
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```
4. 启动 Neovim，lazy.nvim 会自动安装所有插件：
   ```bash
   nvim
   ```


```python
print('hello world')
```

```c
#include <stdio.h>

int main() {
    printf("hello world\n");
    return 0;
}
```

$ X^{2} + Y_{1}^{2} = 2 $


$$
 \lim_{n \to \infty} (1 + \frac{1}{n})^n
$$

