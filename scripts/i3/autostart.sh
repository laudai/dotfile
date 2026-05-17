#!/usr/bin/env bash
# i3 autostart: launch compositor, wallpaper, and conky with dependency checks
# picom must start first (compositor), then wallpaper, then conky (needs compositor for transparency)

# Wait for X server to be ready
until xdpyinfo &>/dev/null; do sleep 0.5; done

picom -b
# Wait for picom to be ready (accepting compositing requests)
until xprop -root _NET_SUPPORTING_WM_CHECK &>/dev/null && pgrep -x picom &>/dev/null; do sleep 0.5; done

nitrogen --restore
# Fix: root window has no cursor defined, so mouse disappears over wallpaper area
xsetroot -cursor_name left_ptr

conky -b
