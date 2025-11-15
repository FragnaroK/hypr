#!/bin/bash

#-------------------------------------------------------------
# Setup environment based on chassis type
#-------------------------------------------------------------

set -euo pipefail

HYPR_CONFIG_PATH="$HOME/.config/hypr"
SCRIPTS_PATH="$HYPR_CONFIG_PATH/scripts"
SETUP_SCRIPTS_PATH="$SCRIPTS_PATH/setup-scripts"

run_setup_script() {
    local script_path="$1"
    local env_type="$2"

    if [[ -f "$script_path" ]]; then
        bash "$script_path" "$env_type"
    else
        echo "Error: Setup script $(basename "$script_path") not found"
        notify-send --urgency=critical "Environment Setup" "Setup script $script_name not found"
        exit 1
    fi
}

setup_env() {
    local setup_scripts
    local env_type=$(bash "$SCRIPTS_PATH/get-chassis.sh")

    for script in "$SETUP_SCRIPTS_PATH"/*; do
        printf "Running setup script: %s for environment: %s\n" "$script" "$env_type"
        run_setup_script "$script" "$env_type"

        if [ "$?" -ne 0 ]; then
            echo "Error: Setup script $script failed"
            notify-send --urgency=critical "Environment Setup" "Setup script $script failed"
            return 1
        fi
    done

    notify-send "Environment Setup" "Set for $env_type chassis"
}

setup_env

if [ "$?" -ne 0 ]; then
    echo "Error: Environment setup failed"
    notify-send --urgency=critical "Environment Setup" "Environment setup failed"
    exit 1
fi

exit 0