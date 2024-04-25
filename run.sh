#!/usr/bin/env bash

ARGS="$@"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
VENV_PATH="$DIR/venv"

setup_venv() {
    command -v /usr/bin/virtualenv >/dev/null 2>&1 || fail "virtualenv is required but it's not installed."

    # Create a virtual environment if it doesn't exist
    if [ ! -d "$VENV_PATH" ]; then
        echo "Creating a virtual environment..."
        /usr/bin/virtualenv "$VENV_PATH"
    fi

    source "$VENV_PATH/bin/activate"

    echo "Installing pip requirements..."
    pip install -r "$DIR/requirements.txt"

}

setup_venv

ansible-galaxy collection install -r roles/requirements.yml
ansible-playbook -K playbook.yml $ARGS
