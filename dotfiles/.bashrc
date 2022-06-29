# ctrl-y copies current bash readline to clipboard
copyline() { printf %s "$READLINE_LINE" | xclip -selection clipboard; }
bind -m "vi-command" -x '"\C-Y": copyline'
bind -m "vi-insert" -x '"\C-Y": copyline'

foocd () {
    # placeholder
    cd $(find $HOME/git -type d | fzf)
}
bind -m "vi-command" '"\C-f": "foocd"'
bind -m "vi-insert" '"\C-f": "\eddiecho foo\C-m"'

lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bind -m "vi-command" '"\C-o": "ddilfcd\C-m"'
bind -m "vi-insert" '"\C-o": "\eddilfcd\C-m"'

bind -m "vi-command" '"\C-k": "ddipushd .. > /dev/null\C-m"'
bind -m "vi-insert" '"\C-k": "\eddipushd .. > /dev/null\C-m"'
_cdup () {
    [[ "$PWD" != "/" ]] && pushd .. > /dev/null
}
bind -m "vi-command" '"\C-k": "ddi_cdup # <==\C-m"'
bind -m "vi-insert" '"\C-k": "\eddi_cdup # <==\C-m"'
_cddown () {
    popd > /dev/null
}
bind -m "vi-command" '"\C-j": "ddi_cddown # ==>\C-m"'
bind -m "vi-insert" '"\C-j": "\eddi_cddown # ==>\C-m"'
_clearcd () {
    if [ $# -eq 0 ]; then
        DIR="${HOME}"
    else
        DIR="$1"
    fi
    cd "${DIR}" && dirs -c
}

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTIGNORE="&:ls:l:clear:pwd:cd .."

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
    xterm-color|*-256color) color_prompt=yes;;
esac

_set_prompt () {
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

#############################################################################
#############################################################################
# for ctrl-r fzf history search
source /usr/share/doc/fzf/examples/key-bindings.bash

# EXPORTS
#############################################################################
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export ANDROID_HOME="$XDG_DATA_HOME"/android
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GOPATH="$XDG_DATA_HOME"/go
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

export EDITOR='nvim'
export VISUAL='nvim'
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)
export _JAVA_AWT_WM_NONREPARENTING=1 # needed for jetbrains software
export PATH=${PATH}:~/.local/share/coursier/bin
#############################################################################

alias tree='tree -C'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ALIASES
#############################################################################
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
alias cd='_clearcd'
#############################################################################

echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1
# needed for st
tput smkx

