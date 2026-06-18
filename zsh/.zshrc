# ==============================
# 非交互模式跳过
# ==============================
if [[ $- != *i* ]]; then
    return
fi

# ==============================
# PATH 配置（Homebrew 优先）
# ==============================
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

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
    z                       # 智能跳转目录
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
[ -s /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -s /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

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
# tldr 中文别名（tealdeer）
# ==============================
alias tldr='tldr -L zh'
alias tldr-update='LANG=zh_CN.UTF-8 tldr --update'

# ==============================
# x-cmd 工具
# ==============================
if [[ -f "$HOME/.x-cmd.root/X" ]]; then
    . "$HOME/.x-cmd.root/X" &>/dev/null
    alias x="___x_cmd"
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
export PATH="$HOME/.dotnet:$PATH"
export PATH="$HOME/.mavis/bin:$PATH"
