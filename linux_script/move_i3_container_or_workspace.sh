#!/usr/bin/env bash

# reference: https://stackoverflow.com/questions/54637049/i3-move-container-to-next-previous-ws-also-if-nonexisting
wsIndex=$(( $( i3-msg -t get_workspaces | jq '.[] | select(.focused).num' ) + $1))
[[ $2 == "move_container" ]] && i3-msg move container to workspace $wsIndex
i3-msg workspace $wsIndex

