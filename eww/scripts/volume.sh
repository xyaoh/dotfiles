#!/usr/bin/env bash
# Dependency :PulseAudio (pavucontrol)
# Output format :Json "{"sink": {"left": "$left", "right": "$right", "mute": "$mute"}
#                       "source": {"left": "$left", "right": "$right", "mute": "$mute"}}"

getVolume() {
  sink=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -e "%" | sed "s/ //g")
  sinkleft=$(echo "$sink" | cut -d "/" -f 2 | sed "s/%//")
  sinkright=$(echo "$sink" | cut -d "/" -f 4 | sed "s/%//")
  sinkmute=$(pactl get-sink-mute @DEFAULT_SINK@ | sed "s/ //g" | cut -d ":" -f 2)
  sink="{\"left\": \"$sinkleft\", \"right\": \"$sinkright\", \"mute\": \"$sinkmute\"}"

  source=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -e "%" | sed "s/ //g")
  sourceleft=$(echo "$source" | cut -d "/" -f 2 | sed "s/%//")
  sourceright=$(echo "$source" | cut -d "/" -f 4 | sed "s/%//")
  sourcemute=$(pactl get-source-mute @DEFAULT_SOURCE@ | sed "s/ //g" | cut -d ":" -f 2)
  source="{\"left\": \"$sourceleft\", \"right\": \"$sourceright\", \"mute\": \"$sourcemute\"}"

  echo "{\"sink\": $sink, \"source\": $source}"
}

# Init value
getVolume

# Listening
pactl subscribe | grep -E --line-buffered "sink|source" |
while read -r UNUSED_LINE; do
  getVolume
done
