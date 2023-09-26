#!/usr/bin/env bash
# Dependency :Hyprland, jq, socat
# Output format :Json {"$id": "$windows"}

getWorkspaces() {
  hyprctl workspaces -j | jq -c 'map({key: .id | tostring, value: .windows | tostring}) | from_entries'
}

# Init value
getWorkspaces

# Listening
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
while read -r UNUSED_LINE; do
  getWorkspaces
done
