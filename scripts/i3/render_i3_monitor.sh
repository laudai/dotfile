#!/usr/bin/env bash
# Author : laudai

# reference: https://github.com/swaywm/sway/wiki
# need to configure your `xrandr --listactivemonitors` output
LAPTOP_INTERNAL_OUTPUT="eDP-1"
EXTERNAL_OUTPUT="HDMI-2"
# need to configure your lid action
LID_STATE_FILE="/proc/acpi/button/lid/LID/state"

read -r LS < "$LID_STATE_FILE"

case "$LS" in
    *open)
        xrandr --auto
        xrandr --output $EXTERNAL_OUTPUT --primary --auto --output $LAPTOP_INTERNAL_OUTPUT --right-of $EXTERNAL_OUTPUT
        ;;
    *closed)
        # will disalbe the internal panel if connect external monitor
        MONITOR_COUNT=$(xrandr --listactivemonitors | awk ' /^Monitors:/ { print $2; exit;}')
        [[ $MONITOR_COUNT -gt 1 ]] && xrandr --output $LAPTOP_INTERNAL_OUTPUT --off
        ;;
    *)
        echo "Could not get lid state" >&2 ; exit 1
        ;;
esac
