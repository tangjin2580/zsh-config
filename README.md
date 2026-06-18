# Zsh 配置管理

macOS zsh 全套配置，一键恢复开发环境。

## 包含内容

| 组件 | 配置 |
|---|---|
| 终端主题 | oh-my-posh (atomic) |
| 历史搜索 | atuin (Ctrl+R) |
| 模糊搜索 | fzf (Ctrl+T 文件 / Alt+C 目录) |
| 语法高亮 | zsh-syntax-highlighting |
| 自动建议 | zsh-autosuggestions (→ 补全) |
| tldr | tealdeer 中文版 |
| 命令纠错 | thefuck |
| 目录跳转 | z、dirhistory |
| 剪贴板 | copypath、copyfile |
| Homebrew | `Brewfile` 一键安装所有包 |

## 重装系统后恢复

```bash
# 1. 克隆配置
git clone git@github.com:tangjin2580/zsh-config.git ~/dotfiles

# 2. 安装
bash ~/dotfiles/install.sh
```

## 日常维护

修改配置后同步到 GitHub：

```bash
cd ~/dotfiles
git add -A
git commit -m "update: 描述你的改动"
git push
```

在新机器上拉取最新配置：

```bash
cd ~/dotfiles && git pull
```
