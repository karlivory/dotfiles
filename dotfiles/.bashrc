#!/bin/bash
#############################################################################
# For ctrl-r fzf history search
# copied from: /usr/share/doc/fzf/examples/key-bindings.bash
# (because I don't want the other keybindings)
__fzfcmd() {
    [[ -n "$TMUX_PANE" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "$FZF_TMUX_OPTS" ]]; } &&
        echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}
__fzf_history__() {
    local output
    output=$(
        builtin fc -lnr -2147483648 |
            last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e 'BEGIN { getc; $/ = "\n\t"; $HISTCMD = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCMD - $. . "\t$_" if !$seen{$_}++' |
            FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) --query "$READLINE_LINE"
    ) || return
    READLINE_LINE=${output#*$'\t'}
    if [[ -z "$READLINE_POINT" ]]; then
        echo "$READLINE_LINE"
    else
        READLINE_POINT=0x7fffffff
    fi
}
bind -m emacs-standard -x '"\C-r": __fzf_history__'
bind -m vi-command -x '"\C-r": __fzf_history__'
bind -m vi-insert -x '"\C-r": __fzf_history__'
#############################################################################

tmux_sessionizer() {
    tmux-sessionizer
}

bind -x '"\C-x": tmux_sessionizer'
bind -m "vi-command" '"\C-x": "i\C-x"'

# ctrl-y copies current bash readline to clipboard
copyline() { printf %s "$READLINE_LINE" | xclip -selection clipboard; }
bind -m "vi-command" -x '"\C-Y": copyline'
bind -m "vi-insert" -x '"\C-Y": copyline'

# WOOOOOOOOOOOOOOOOOOOOW SO EFFECTIVE
bind -m "vi-command" -x '"\C-g": git status'
bind -m "vi-insert" -x '"\C-g": git status'

# BEST FUNCTION EVER!!!
_common_dirs() {
    dir=$("$HOME/.config/vars/common_dirs" | fzf)
    [[ -n "$dir" ]] && cd "$dir" || return
}
bind -m "vi-command" '"\C-f": "ddi_common_dirs\C-m"'
bind -m "vi-insert" '"\C-f": "\eddi_common_dirs\C-m"'

# Mildly useful
lfcd() {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return
    fi
}
bind -m "vi-command" '"\C-o": "ddilfcd\C-m"'
bind -m "vi-insert" '"\C-o": "\eddilfcd\C-m"'

# Kinda nice. ctrl-j/k to go up directories fast. Using cd clears the stack
_cdup() {
    [[ "$PWD" != "/" ]] && pushd .. >/dev/null
}
bind -m "vi-command" '"\C-k": "ddi_cdup # <==\C-m"'
bind -m "vi-insert" '"\C-k": "\eddi_cdup # <==\C-m"'
_cddown() {
    popd >/dev/null
}
bind -m "vi-command" '"\C-e": "ddi_cddown # ==>\C-m"'
bind -m "vi-insert" '"\C-e": "\eddi_cddown # ==>\C-m"'
_clearcd() {
    if [ $# -eq 0 ]; then
        DIR="${HOME}"
    else
        DIR="$1"
    fi
    cd "${DIR}" && dirs -c
}
alias cd='_clearcd'

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

if [[ -t 0 && $- = *i* ]]; then
    stty -ixon
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTIGNORE="&:ls:l:clear:pwd:cd ..:_cdup # <==:_cddown # ==>:tmux-sessionizer"

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

_set_prompt() {
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# EXPORTS
#############################################################################
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export ANDROID_HOME="$XDG_DATA_HOME"/android
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export GOPATH=$HOME/go

export EDITOR='nvim'
export VISUAL='nvim'
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)
export _JAVA_AWT_WM_NONREPARENTING=1 # needed for jetbrains software
export PATH=${PATH}:~/.local/share/coursier/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=${PATH}:$HOME/go/bin

# for colored man-pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
#############################################################################

# ALIASES
#############################################################################
alias tree='tree -C'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias l='ls -alF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias xc='xclip -selection clipboard'
alias xv='xclip -selection clipboard -o'
alias vpn='sudo openvpn --config'
alias rsa='redshift -PO 6500'
alias rsb='redshift -PO 3000'
alias b='bluetoothctl'
alias v='nvim'
alias drm='docker rm $(docker ps -q) --force'
alias cdg='cd $(git rev-parse --show-toplevel)'
alias fcd='cd $(find -type d 2>/dev/null | fzf)'
alias lf='lfub'
alias cx='chmod +x'
alias gc="git commit -m"
alias gcn="git commit --no-gpg-sign -m"
alias gd="git diff"
alias gr="git restore --staged"
alias ga="git add"
alias yt1080="yt-dlp -f 'bestvideo[height<=1080]+bestaudio'"
alias yt1440="yt-dlp -f 'bestvideo[height<=1440]+bestaudio'"
alias lm="sudo zfs mount zroot/log"
alias lu="sudo zfs umount zroot/log && sudo rm -rf /log"
alias p="python3"
alias z="zfs-snapshot-browser"
alias wt='wrap "tt -n 20"'
alias ve='virtualenv venv && source venv/bin/activate'
#############################################################################

# kubectl completion
alias k=kubectl
complete -o default -F __start_kubectl k
source <(kubectl completion bash)

echo "UPDATESTARTUPTTY" | gpg-connect-agent >/dev/null 2>&1
# needed for st
tput smkx
. "$HOME/.cargo/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
export PATH="/home/karl/.local/share/fnm:$PATH"
eval "`fnm env`"
