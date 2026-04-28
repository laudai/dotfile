#!/usr/bin/env bash

# get the display resolution
read SCREEN_W SCREEN_H < <(xdotool getdisplaygeometry)

# check the polybar height if avaliable
BAR_ID=$(xdotool search --class "Polybar" | head -n 1)
if [ -n "$BAR_ID" ]; then
    BAR_H=$(xwininfo -id "$BAR_ID" | awk '/Height:/ {print $2}')
    BAR_Y=$(xwininfo -id "$BAR_ID" | awk '/Absolute upper-left Y:/ {print $4}')
    TOP_GAP=$((BAR_H + BAR_Y))
else
	# The px in my polybar (20pt x 1.33)
    TOP_GAP=26
fi

# available height
AVAIL_H=$((SCREEN_H - TOP_GAP))

# position layout
case $1 in
    left)
        X=0; Y=$TOP_GAP; W=$((SCREEN_W / 2)); H=$AVAIL_H
        ;;
    right)
        X=$((SCREEN_W / 2)); Y=$TOP_GAP; W=$((SCREEN_W / 2)); H=$AVAIL_H
        ;;
    top)
        X=0; Y=$TOP_GAP; W=$SCREEN_W; H=$((AVAIL_H / 2))
        ;;
    bottom)
        X=0; Y=$((TOP_GAP + AVAIL_H / 2)); W=$SCREEN_W; H=$((AVAIL_H / 2))
        ;;
    reset)
        i3-msg "floating disable"
        exit 0
        ;;
    *)
        echo "Usage: $0 {left|right|top|bottom|reset}"
        exit 1
        ;;
esac

i3-msg "floating enable; \
     resize set $W px $H px; \
    move position $X px $Y px"
