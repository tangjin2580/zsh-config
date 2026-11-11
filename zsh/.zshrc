# ==============================
# 非交互模式跳过
# ==============================
if [[ $- != *i* ]]; then
    return
fi

# ==============================
# PATH 配置
# ==============================
# Homebrew 与 ~/.local/bin 已由 ~/.zprofile 统一设置，此处不再重复 export。
# 去重由 ~/.zshenv 的 `typeset -U path PATH` 保证。

# ==============================
# fzf 模糊搜索（Ctrl+T 搜文件、Alt+C 跳目录）
# ==============================
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# ==============================
# oh-my-zsh 配置
# ==============================
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    extract                 # 解压各种压缩文件
    colored-man-pages       # 彩色 man 文档
    command-not-found       # 未找到命令提示安装
    brew                    # Homebrew 补全与别名
    macos                   # macOS 专用命令（pfd/pbcopy 等）
    copypath                # 复制当前路径到剪贴板
    copyfile                # 复制文件内容到剪贴板
    dirhistory              # Alt+←→ 导航目录历史
    web-search              # 命令行快速搜索
    sudo                    # 按两次 ESC 自动加 sudo
    docker                  # Docker 别名
    docker-compose          # Docker Compose 别名
)

source "$ZSH/oh-my-zsh.sh"

# ==============================
# 基本设置
# ==============================
export LANG=en_US.UTF-8
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche

# ==============================
# oh-my-posh 主题
# ==============================
if command -v oh-my-posh >/dev/null 2>&1; then
    eval "$(oh-my-posh init zsh --config "$(brew --prefix oh-my-posh)/themes/atomic.omp.json")"
fi

# ==============================
# 插件：语法高亮 & 自动建议（须在 atuin 之前加载）
# ==============================
[ -s $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -s $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ==============================
# Atuin 历史命令（仅 Ctrl+R 触发，不占用 ↑↓）
# ==============================
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# ==============================
# History 配置
# ==============================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS   # 忽略重复命令
setopt HIST_IGNORE_SPACE      # 忽略空格开头的命令
setopt HIST_REDUCE_BLANKS     # 去除多余空格
setopt SHARE_HISTORY          # 跨终端共享历史

# ==============================
# 常用别名
# ==============================
alias ll='ls -alhF'
alias la='ls -Ah'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias ip='curl -s https://ifconfig.me && echo'

# ==============================
# dotfiles 管理命令
# ==============================
dotfiles() {
    case "${1:-}" in
        push)   cd ~/dotfiles && git add -A && git commit -m "${2:-update}" && git push ;;
        pull)   cd ~/dotfiles && git pull ;;
        edit)   ${EDITOR:-vim} ~/dotfiles/zsh/.zshrc ;;
        status) cd ~/dotfiles && git status ;;
        log)    cd ~/dotfiles && git log --oneline -10 ;;
        *)      echo "用法: dotfiles {push|pull|edit|status|log} [commit信息]" ;;
    esac
}
# ==============================
# 文件夹备注（cd 进入目录时自动显示 .notes 文件内容）
# ==============================
autoload -Uz add-zsh-hook
chpwd_show_note() {
    if [[ -f .notes ]]; then
        printf '\033[33m📁 %s:\033[0m \033[36m%s\033[0m\n' "$(basename "$PWD")" "$(head -1 .notes)"
    fi
}
add-zsh-hook chpwd chpwd_show_note

note() {
    if [[ -z "$1" ]]; then
        cat .notes 2>/dev/null || echo "用法: note '你的备注'"
    else
        echo "$1" > .notes && echo "✓ 备注已保存: $1"
    fi
}

# ==============================
# tldr 中文别名（tealdeer）
# ==============================
alias tldr='tldr --language zh'
alias tldr-update='tldr --update'

# ==============================
# 端口查询工具
# ==============================
# 查看指定端口的监听进程（用法：listen 5128）
listen() {
    lsof -nP -iTCP:"$1" -sTCP:LISTEN
}
# 列出本机所有监听端口（用法：openports）
openports() {
    lsof -nP -iTCP -sTCP:LISTEN
}
# 杀掉监听指定端口的进程（用法：killport 5128；强制：killport -9 5128）
killport() {
    local sig="" port="$1"
    [[ "$1" == "-9" || "$1" == "-KILL" ]] && { sig="-9"; port="$2"; }
    local pid
    pid=$(lsof -tiTCP:"$port" -sTCP:LISTEN -nP)
    if [[ -n "$pid" ]]; then
        echo "→ 终止监听端口 $port 的进程 PID: $pid"
        kill $sig $pid
    else
        echo "✗ 没有进程监听端口 $port"
    fi
}

# ==============================
# zoxide：基于 frecency 的目录跳转（替代原先不可靠的 x-cmd c）
# 每次 cd / 任意方式切目录都会被自动记录，c 关键词即可模糊跳回
# ==============================
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# ==============================
# x-cmd 工具（保留 x 命令本身，c 已改映射 zoxide）
# ==============================
if [[ -f "$HOME/.x-cmd.root/X" ]]; then
    . "$HOME/.x-cmd.root/X" &>/dev/null
    alias x="___x_cmd"
    # c 原映射 x cd，现改为 zoxide（模糊跳转更可靠，且自动学习普通 cd）
    alias c='z'
fi

# ==============================
# thefuck 命令纠错
# ==============================
if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias)"
    eval "$(thefuck --alias FUCK)"
fi

# ==============================
# Docker CLI 补全
# ==============================
fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit && compinit -u

# ==============================
# JetBrains IDE JVM 参数
# ==============================
[ -s "$HOME/.jetbrains.vmoptions.sh" ] && . "$HOME/.jetbrains.vmoptions.sh"

# ==============================
# 其他 PATH
# ==============================
# ~/.dotnet 已在 ~/.zprofile 设置。
# ~/.mavis/bin 原先被 MiniMax 工具重复写入两次，这里合并为一次。
path=("$HOME/.mavis/bin" $path)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ==============================
# 中文 man 手册（man-pages-zh，装在 $HOMEBREW_PREFIX/share/man/zh_CN）
# 用法：cman <命令>   例：cman ls
# 说明：仅在调用时把 LANG 切到 zh_CN.UTF-8，不影响全局会话；
#       MANPATH 末尾的冒号表示追加系统默认 man 路径，作为英文回退；
#       显式带上 $HOMEBREW_PREFIX/share/man 让 Homebrew 命令（如 git）的
#       英文页也能回退。若想让 `man` 默认显示中文，可加 alias man='cman'。
# ==============================
cman() {
    LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 \
    MANPATH=$HOMEBREW_PREFIX/share/man/zh_CN:$HOMEBREW_PREFIX/share/man: \
    command man "$@"
}

# 让 `man` 默认显示中文（有中文页用中文，没有则回退英文）
alias man='cman'
