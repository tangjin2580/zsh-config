#!/bin/bash
# Zsh Dotfiles 安装脚本
# 用法: bash install.sh

set -e
DOTFILES="$HOME/dotfiles"

echo "==> 1/5 安装 Homebrew 包..."
if ! command -v brew &>/dev/null; then
    echo "    未安装 Homebrew，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle --file="$DOTFILES/Brewfile"
# macOS 专属依赖（cask / 部分 formula / vscode 扩展在 Linux 上 brew bundle 会报错，仅 Darwin 运行）
if [ "$(uname)" = "Darwin" ]; then
    brew bundle --file="$DOTFILES/Brewfile.macos"
fi

echo ""
echo "==> 2/5 创建配置软链接..."
ln -sf "$DOTFILES/zsh/.zshrc"   "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$DOTFILES/zsh/.zshenv"  "$HOME/.zshenv"
mkdir -p "$HOME/Library/Application Support/tealdeer"
ln -sf "$DOTFILES/tealdeer/config.toml" "$HOME/Library/Application Support/tealdeer/config.toml"

echo ""
echo "==> 3/5 启动守护进程..."
if command -v atuin &>/dev/null; then
    atuin daemon start 2>/dev/null || true
fi

echo ""
echo "==> 4/5 下载 tldr 页面缓存（中/英）..."
if command -v tldr &>/dev/null; then
    tldr --update
fi

echo ""
echo "==> 5/5 安装中文 man 手册（需联网，失败不影响其余配置）..."
if bash "$DOTFILES/install-man-zh.sh"; then
    echo "    中文 man 手册安装完成"
else
    echo "    ⚠️ 中文 man 安装失败（可能无网络），可稍后手动运行："
    echo "       bash ~/dotfiles/install-man-zh.sh"
fi

echo ""
echo "=============================================="
echo "  安装完成！新开终端或执行 source ~/.zshrc"
echo "=============================================="
