#!/usr/bin/env bash

#-------------------------------------------------------------
# Switch between Desktop and Laptop monitor/workspace configs
#-------------------------------------------------------------

set -euo pipefail

CUSTOM_CONFIG_PATH="$HOME/.config/hypr/monitors"
MONITOR_CONFIG_PATH="$HOME/.config/hypr/monitors.conf"
WORKSPACES_CONFIG_PATH="$HOME/.config/hypr/workspaces.conf"

# Get chassis if not provided (desktop|laptop|server)
if [ "${1-}" ]; then
  CHASSIS="$1"
else
  if chassis_out=$(hostnamectl chassis 2>/dev/null) && [ -n "$chassis_out" ]; then
    CHASSIS="$chassis_out"
  else
    CHASSIS="$(hostnamectl 2>/dev/null | awk -F: '/^[[:space:]]*Chassis:/ {print $2}' | xargs || true)"
  fi
fi

: "${CHASSIS:=unknown}"

selected_env=$(echo "$CHASSIS" | awk '{print tolower($0)}')

toggle_config() {
    local source_monitors_path="$CUSTOM_CONFIG_PATH/monitors-$1.conf"
    local source_workspaces_path="$CUSTOM_CONFIG_PATH/workspaces-$1.conf"

    cp -fv "$source_monitors_path" "$MONITOR_CONFIG_PATH"
    cp -fv "$source_workspaces_path" "$WORKSPACES_CONFIG_PATH"

    if [ $? -ne 0 ]; then
        echo "Error: Could not set $1 mode"
        notify-send --urgency=critical "Environment Setup" "Could not set $1 mode"
        exit 1
    fi

    echo "Monitors config set to $1 mode"
    notify-send "Environment Setup" "Monitors config set to $1 mode"
}

if [[ "$selected_env" == "desktop" ]] || [[ "$selected_env" == "laptop" ]]; then
    toggle_config "$selected_env"
else
    echo "Error: Option $selected_env not implemented"
    notify-send "Environment Setup" "Option $selected_env not implemented"
    exit 1
fi
 
exit 0