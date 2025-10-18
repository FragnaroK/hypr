#!/usr/bin/env bash

#-------------------------------------------------------------
# Switch between Desktop and Laptop window rules
#-------------------------------------------------------------

set -euo pipefail

CUSTOM_CONFIG_PATH="$HOME/.config/hypr/conf/windowrules/custom"
WINDOWRULES_CONFIG_PATH="$HOME/.config/hypr/conf/windowrules/custom.conf" 

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
    local source_path="$CUSTOM_CONFIG_PATH/windowrules-$1.conf"

    cp -fv "$source_path" "$WINDOWRULES_CONFIG_PATH"

    if [ $? -ne 0 ]; then
        echo "Error: Could not set $1 window rules"
        notify-send --urgency=critical "Environment Setup" "Could not set $1 window rules"
        exit 1
    fi

    echo "Monitors config set to $1 window rules"
    notify-send "Environment Setup" "Window rules config set to $1 "
}

if [[ "$selected_env" == "desktop" ]] || [[ "$selected_env" == "laptop" ]]; then
    toggle_config "$selected_env"
else
    echo "Error: Window rules $selected_env not implemented"
    notify-send "Environment Setup" "Window rules $selected_env not implemented"
    exit 1
fi
 
exit 0