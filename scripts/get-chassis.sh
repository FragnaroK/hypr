#!/usr/bin/env bash
set -euo pipefail

if chassis_out=$(hostnamectl chassis 2>/dev/null) && [ -n "$chassis_out" ]; then
    CHASSIS="$chassis_out"
else
    CHASSIS="$(hostnamectl 2>/dev/null | awk -F: '/^[[:space:]]*Chassis:/ {print $2}' | xargs || true)"
fi

: "${CHASSIS:=unknown}"

echo "$CHASSIS" | awk '{print tolower($0)}'