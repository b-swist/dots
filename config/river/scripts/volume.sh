#!/bin/sh

get_volume() {
	echo "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F ': ' '{print $2 * 100}')%"
}

send_notify() {
	notify-send "Current volume" "$(get_volume)"
}

change_volume() {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1" -l 1
}

change_volume "$1"
send_notify
