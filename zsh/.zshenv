# ~/.zshenv — 对所有 zsh 调用生效（登录/交互/脚本），最早被读取
#
# path 与 PATH 绑定为「唯一数组」：zsh 会自动去掉重复项，只保留首次出现的位置。
# 这样无论后续 .zprofile / .zshrc / 第三方安装脚本往 PATH 里加多少次，
# 都不会再出现重复条目。
typeset -U path PATH
typeset -U fpath
typeset -U manpath MANPATH

# ── Homebrew 前缀自动探测（macOS / Linuxbrew 通用）──────────
# 放在 .zshenv：它对「登录/非登录、交互/非交互」所有 zsh 都最先生效，
# 保证 brew 及其工具（zoxide / fzf / oh-my-posh ...）在任意 shell 下都进得了 PATH，
# 且 macOS(Apple Silicon=/opt/homebrew、Intel=/usr/local) 与 Linux(/home/linuxbrew/.linuxbrew) 自动适配。
if [ -x /opt/homebrew/bin/brew ]; then
    HOMEBREW_PREFIX=/opt/homebrew
elif [ -x /usr/local/bin/brew ]; then
    HOMEBREW_PREFIX=/usr/local
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
fi
if [ -n "$HOMEBREW_PREFIX" ]; then
    export HOMEBREW_PREFIX
    # 仅当尚未在 PATH 中时加入（typeset -U 也会去重）
    case ":$PATH:" in
        *":$HOMEBREW_PREFIX/bin:"*) ;;
        *) path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path) ;;
    esac
fi
