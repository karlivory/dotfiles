#!/usr/bin/env bash

if [ "$0" != "./run.sh" ]; then
    echo -e "\033[33mWARNING: script was run outside of its directory. Fixing...\033[0m"
    cd "$(dirname "$0")"
fi

if ! command -v unbuffer &> /dev/null
then
    echo "expect not installed! Installing..."
    sudo apt install expect -y
fi

function sigint_handler()
{
    echo "Execution halted via SIGINT!" | tee -a $logfile
    exit
}
function invalid_tag()
{
    echo "Invalid tag! Exiting..." | tee -a $logfile
    exit 1
}
function root_playbook(){
    sudo ansible-galaxy install -r roles/requirements.yml
    sudo unbuffer ansible-playbook playbook.yml $sudo_tags_arg 2>&1 | tee -a $logfile
}
function user_playbook(){
    ansible-galaxy install -r roles/requirements.yml
    unbuffer ansible-playbook playbook_user.yml $user_tags_arg 2>&1 | tee -a $logfile
}
trap sigint_handler SIGINT

mkdir -p logs
logfile="logs/ansible-$(date +%F)"
touch $logfile
echo "============================ $(date) ============================" >> "$logfile"

sudo_tags_arg=""
user_tags_arg=""
all=0
if [ ! $# -eq 0 ]
then
    case $1 in
        system|fonts|dotfiles|desktop|neovim|software|virt)
            sudo_tags_arg="-t $1" ;;
        repos)
            user_tags_arg="-t $1" ;;
        *)
            invalid_tag ;;
    esac

    echo "Running playbook with given tag: $1" | tee -a $logfile
fi

if ! command -v ansible &> /dev/null
then
    echo "Ansible not installed! Installing..."
    sudo apt install ansible -y
fi


if [[ -z $sudo_tags_arg && -z $user_tags_arg ]]
then
    echo "No tags specified. Running all tasks..."
    root_playbook
    user_playbook
elif [[ ! -z $sudo_tags_arg ]]
then
    echo "Running root playbook with tag: $1"
    root_playbook
elif [[ ! -z $user_tags_arg ]]
then
    echo "Running user playbook with tag: $1"
    user_playbook
fi

