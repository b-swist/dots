#!/bin/sh

if [ "$1" = "all" ]; then
	grim - | wl-copy && notify-send "Screenshot taken"
else
	grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot taken"
fi
