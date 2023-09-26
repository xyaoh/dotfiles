#!/usr/bin/env bash
# Dependency :Hyprland, jq, socat
# Output format :Integer

# Init value
hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'

# Listening
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
  stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'
