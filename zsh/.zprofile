# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/Mr.li/.docker/bin"
# End of Docker Desktop section.

# ~/.zprofile — 登录 shell 环境（PATH / 环境变量的唯一权威来源）
# 去重由 ~/.zshenv 的 `typeset -U path PATH` 自动保证。
# 整理于 2026-08-03（原文件已备份至 ~/env-repair-backup-20260803-143406/）

# ── Homebrew ────────────────────────────────────────────────
# HOMEBREW_PREFIX 与 PATH 中的 brew bin 已由 ~/.zshenv 探测并加入（跨平台通用），
# 这里仅对「登录 shell」跑完整 shellenv，补上 MANPATH / CPATH / HOMEBREW_* 等环境变量。
[ -n "$HOMEBREW_PREFIX" ] && eval "$(brew shellenv)"

# 国内镜像（zsh 与 bash 现已统一为 USTC，原先 .bash_profile 用的是清华，两边不一致）
export HOMEBREW_API_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles/api
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles/bottles
export HOMEBREW_PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/

# ── Python 3.10 (python.org 安装器) ─────────────────────────
# 保留，但排在 Homebrew 之后：`python3` 会解析到 Homebrew 的 3.14。
# 如需专门使用 3.10，用完整路径或 `python3.10`。
path+=("/Library/Frameworks/Python.framework/Versions/3.10/bin")

# ── 其它用户级 bin ──────────────────────────────────────────
path=("$HOME/.local/bin" "$HOME/.dotnet" $path)

# ── Java ────────────────────────────────────────────────────
# 显式锁定 JDK 17（与整理前 `java -version` 的实际结果一致，不改变现有行为）。
# 机器上还装有 Oracle JDK 8 与 Homebrew openjdk 25，切换方式：
#   export JAVA_HOME=$(/usr/libexec/java_home -v 25)
if [ -x /usr/libexec/java_home ]; then
    export JAVA_HOME="$(/usr/libexec/java_home -v 17 2>/dev/null)"
fi

# ── 代理例外 ────────────────────────────────────────────────
# 本机回环与内网不走代理，避免 localhost 请求被绕进 Clash。
export NO_PROXY="localhost,127.0.0.1,::1,*.local,*.lan,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
export no_proxy="$NO_PROXY"

# ── 剔除 PATH 中不存在的目录 ────────────────────────────────
# （例如未挂载的外置卷、已卸载软件留下的路径）
path=(${^path}(N-/))
