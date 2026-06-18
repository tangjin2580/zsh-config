#!/bin/bash
# Zsh Dotfiles 安装脚本
# 用法: bash install.sh

set -e
DOTFILES="$HOME/dotfiles"

echo "==> 1/4 安装 Homebrew 包..."
if ! command -v brew &>/dev/null; then
    echo "    未安装 Homebrew，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle --file="$DOTFILES/Brewfile"

echo ""
echo "==> 2/4 创建配置软链接..."
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config/tealdeer"
ln -sf "$DOTFILES/tealdeer/config.toml" "$HOME/.config/tealdeer/config.toml"

echo ""
echo "==> 3/4 启动守护进程..."
if command -v atuin &>/dev/null; then
    atuin daemon start 2>/dev/null || true
fi

echo ""
echo "==> 4/4 下载 tldr 中文缓存..."
if command -v tldr &>/dev/null; then
    LANG=zh_CN.UTF-8 tldr --update
fi

echo ""
echo "=============================================="
echo "  安装完成！新开终端或执行 source ~/.zshrc"
echo "=============================================="
