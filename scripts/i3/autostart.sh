#!/usr/bin/env bash
# i3 autostart: launch compositor, wallpaper, and conky in correct order
# picom must start first (compositor), then wallpaper, then conky (needs compositor for transparency)

sleep 1
picom -b

sleep 1
nitrogen --restore
# Fix: root window has no cursor defined, so mouse disappears over wallpaper area
xsetroot -cursor_name left_ptr

sleep 1
conky -b
