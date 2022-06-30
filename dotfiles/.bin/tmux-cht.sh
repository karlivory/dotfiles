#!/usr/bin/env bash
# credit to theprimeagen

selected=`cat $HOME/.config/vars/.tmux-cht-languages $HOME/.config/vars/.tmux-cht-commands | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" "$HOME/.config/vars/.tmux-cht-languages"; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl -sm 3 cht.sh/$selected/$query | batcat --style=grid --paging=always"
else
    tmux neww bash -c "curl -m 3 -s cht.sh/$selected~$query | batcat --style=grid --paging=always"
fi
