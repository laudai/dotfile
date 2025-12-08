#!/usr/bin/env bash

I3_CONFIG="$HOME/.config/i3/config"

while IFS= read -r line; do

	# VAR_NAME remove the symbol $
    VAR_NAME=$(echo "$line" | awk '{print $2}' | tr -d '$')
	# VAR_VALUE remove the symbol "
    VAR_VALUE=$(echo "$line" | awk '{print $3}' | tr -d '"')

    export $VAR_NAME="$VAR_VALUE"
done < <(grep -E '^\s*set \$ws[0-9]{1,2}\s+' "$I3_CONFIG")

# reference: https://stackoverflow.com/questions/54637049/i3-move-container-to-next-previous-ws-also-if-nonexisting
wsIndex=$(( $( i3-msg -t get_workspaces | jq '.[] | select(.focused).num' ) + $1))
TARGET_VAR_NAME="ws$wsIndex"
# get the value via Indirect expansion
TARGET_WS_NAME="${!TARGET_VAR_NAME}"
[[ $2 == "move_container" ]] && i3-msg move container to workspace $TARGET_WS_NAME
i3-msg workspace $TARGET_WS_NAME

