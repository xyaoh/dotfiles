#!/usr/bin/env bash
# Dependency :NetworkManager
# Output format :Json "{"status": "$status", "ssid": "$ssid"}"

getInitialStatus() {
  ssid=$(nmcli -f IN-USE,SSID device wifi | grep "*")
  if [[ "$ssid" == "" ]]
  then
    echo "{\"status\": \"disconnected\", \"ssid\": \"\"}"
  else
    ssid=$(echo "$ssid" | sed "s/*//" | sed "s/ //g")
    echo "{\"status\": \"connected\", \"ssid\": \"$ssid\"}"
  fi
}

parseStatus() {
  if [[ "$1" == "connected" ]]
  then
    status="connected"
    ssid=$(nmcli -f IN-USE,SSID device wifi | grep "*" | sed "s/*//" | sed "s/ //g")
  elif [[ "$1" == "connecting" ]]
  then
    status="connecting"
    ssid=""
  else
    status="disconnected"
    ssid=""
  fi
  echo "{\"status\": \"$status\", \"ssid\": \"$ssid\"}"
}

# Init value
getInitialStatus

# Listening
nmcli monitor | grep --line-buffered "state" |
while read -r line; do
  status=$(echo "$line" | sed "s/ //g" | cut -d "'" -f 2)
  parseStatus $status
done

