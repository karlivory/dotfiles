#!/usr/bin/env bash

if [ "$0" != "./run.sh" ]; then
    echo -e "\033[33mWARNING: script was run outside of its directory. Fixing...\033[0m"
    cd "$(dirname "$0")"
fi

function sigint_handler()
{
    echo "Execution halted via SIGINT!" | tee -a $logfile
    exit
}
trap sigint_handler SIGINT

mkdir -p logs
logfile="logs/ansible-$(date +%F)"
touch $logfile
echo "============================ $(date) ============================" >> "$logfile"

if ! command -v ansible &> /dev/null
then
    echo "Ansible not installed!"
    sudo apt install ansible -y
fi
#sudo apt install python3-pip -y
#sudo pip install ansible

sudo ansible-galaxy install -r roles/requirements.yml

tags_arg=""
if [ ! $# -eq 0 ]
then
    echo "Running playbook with given tag: $1" | tee -a $logfile
    tags_arg="-t $1"
fi

sudo unbuffer ansible-playbook playbook.yml $tags_arg 2>&1 | tee -a $logfile

