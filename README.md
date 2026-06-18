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
| 文件夹备注 | cd 目录自动显示 `.notes` |
| 剪贴板 | copypath、copyfile |
| Homebrew | `Brewfile` 一键安装所有包 |

## 重装系统后恢复

```bash
git clone git@github.com:tangjin2580/zsh-config.git ~/dotfiles
bash ~/dotfiles/install.sh
```

## 日常维护

只需记一个命令：**`dotfiles`**

```bash
dotfiles push "改了xxx"   # 提交并推送到 GitHub
dotfiles pull             # 从 GitHub 拉取最新配置
dotfiles edit             # 编辑 .zshrc
dotfiles status           # 查看改动
dotfiles log              # 查看提交历史
```

## 文件夹备注

```bash
note "Python 项目"        # 给当前目录写备注
cd ~/project              # 进入目录自动显示：📁 project: Python 项目
note                      # 查看当前目录备注
```
