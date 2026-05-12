#!/usr/bin/env bash
# i3 autostart: launch compositor, wallpaper, and conky in correct order
# picom must start first (compositor), then wallpaper, then conky (needs compositor for transparency)

sleep 1
picom -b

sleep 1
nitrogen --restore

sleep 1
conky -b
