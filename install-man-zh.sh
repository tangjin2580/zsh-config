#!/bin/bash
# 中文 man 手册安装脚本（上游：github.com/man-pages-zh/manpages-zh）
# 适用：macOS（Apple Silicon / Intel 通用，依赖 Homebrew）
#
# 用法：
#   bash install-man-zh.sh            # 已安装则跳过，否则安装
#   FORCE=1 bash install-man-zh.sh    # 强制重新下载、编译、安装
#
# 要点：
#   - 走 codeload.github.com 下载源码 tarball；你的代理只拦 git clone 智能协议，
#     放行 tarball，所以这里【不要改成 git clone】，否则会 502。
#   - 用 CMake 编译，依赖 cmake + opencc（缺失时自动 brew install）。
#   - 安装到 $PREFIX/share/man/zh_CN（PREFIX 取 brew --prefix）。
#   - 该仓库源码即 UTF-8，经 opencc -c t2s.json 输出简体，无需手动转码；
#     macOS 自带 mandoc 渲染 UTF-8，不需要额外装 groff。
#   - 配套的 cman 命令与 `alias man='cman'` 在 zsh/.zshrc 里（install.sh 会软链）。

set -euo pipefail

FORCE="${FORCE:-0}"

# 仅支持 macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ 该脚本仅支持 macOS" >&2
    exit 1
fi

# 取 Homebrew 前缀（Apple Silicon=/opt/homebrew，Intel=/usr/local）
if command -v brew >/dev/null 2>&1; then
    PREFIX="$(brew --prefix)"
else
    echo "❌ 未找到 Homebrew，请先安装 Homebrew 后再运行本脚本" >&2
    exit 1
fi
echo "==> Homebrew prefix: $PREFIX"

ZH_DIR="$PREFIX/share/man/zh_CN"

# 已安装检测（非强制模式）：有页面就跳过
if [[ "$FORCE" != "1" ]] && compgen -G "$ZH_DIR/man*/*.[0-9]*" >/dev/null 2>&1; then
    COUNT=$(find "$ZH_DIR" -name '*.[0-9]*' 2>/dev/null | wc -l | tr -d ' ')
    if [[ "${COUNT:-0}" -gt 0 ]]; then
        echo "✅ 已安装中文 man 手册（$COUNT 页），跳过。FORCE=1 可强制重装。"
        exit 0
    fi
fi

# 依赖：cmake + opencc
echo "==> 检查依赖 cmake / opencc ..."
for pkg in cmake opencc; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "    安装 $pkg ..."
        brew install "$pkg"
    fi
done

# 下载源码 tarball（master 优先，回退 main）
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"

URL=""
BR=""
for br in master main; do
    u="https://codeload.github.com/man-pages-zh/manpages-zh/tar.gz/refs/heads/$br"
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 "$u")
    if [[ "$code" == "200" ]]; then URL="$u"; BR="$br"; break; fi
done
if [[ -z "$URL" ]]; then
    echo "❌ 下载 man-pages-zh 源码失败（网络不通或仓库分支变动）" >&2
    exit 1
fi
echo "==> 下载源码（$BR 分支）..."
curl -fsSL --max-time 60 -o mpz.tar.gz "$URL"
tar xzf mpz.tar.gz
SRC=$(find . -maxdepth 1 -type d -name 'manpages-zh-*' | head -1)
if [[ -z "$SRC" ]]; then
    echo "❌ 解包后未找到 manpages-zh-* 源码目录" >&2
    exit 1
fi
cd "$SRC"

# 编译并安装（仅简体，关闭繁体）
echo "==> 配置 / 编译 / 安装 ..."
cmake -S . -B build -DCMAKE_INSTALL_PREFIX="$PREFIX" -DENABLE_ZHTW=OFF
cmake --build build -j"$(sysctl -n hw.ncpu)"
cmake --install build

# 校验
COUNT=$(find "$ZH_DIR" -name '*.[0-9]*' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${COUNT:-0}" -eq 0 ]]; then
    echo "❌ 安装后未在 $ZH_DIR 找到中文 man 页" >&2
    exit 1
fi
echo "✅ 安装完成：$COUNT 页中文 man -> $ZH_DIR"
echo "   使用：cman ls   （zsh/.zshrc 已配置 cman 与 alias man='cman'）"
