#!/bin/bash
# Dotfiles 安装脚本
# 用法: bash install.sh

set -e
DOTFILES="$HOME/dotfiles"

echo "==> 安装 Homebrew 包..."
brew bundle --file="$DOTFILES/Brewfile"

echo "==> 创建软链接..."
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config/tealdeer"
ln -sf "$DOTFILES/tealdeer/config.toml" "$HOME/.config/tealdeer/config.toml"

# 下载 tldr 中文缓存
if command -v tldr &>/dev/null; then
    echo "==> 更新 tldr 中文缓存..."
    LANG=zh_CN.UTF-8 tldr --update
fi

echo "==> 完成！新开终端即可生效。"
