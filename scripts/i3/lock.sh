#!/usr/bin/env bash
# i3lock wrapper: turn off screen 60s after lock, restore 900s on unlock
xset dpms 60 60 60
i3lock --nofork --image ~/Pictures/wallpaper/731739_blurred.png
xset dpms 900 900 900
