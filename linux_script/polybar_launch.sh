#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

MYBAR_LOG_PATH=/tmp/polybar_mybar.log
# Launch mybar
echo "---" | tee -a $MYBAR_LOG_PATH
polybar mybar 2>&1 | tee -a $MYBAR_LOG_PATH & disown

echo "Bars launched..."
