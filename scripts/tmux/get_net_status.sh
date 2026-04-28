#!/usr/bin/env bash

# get interface name script :
# https://stackoverflow.com/questions/38182286/get-interface-name-into-linux-shell-script-variable/53629106

# get the net device name start with e* or w* if it is connected, to show on tmux status bar.

wlName=$(ip addr show | awk '/inet.*brd/{print $NF}' | grep -o -P '^w.*')
enName=$(ip addr show | awk '/inet.*brd/{print $NF}' | grep -o -P '^e.*')

[[ -z $wlName && -z $enName ]] && no_interface_msg="no w* or e* interface" && echo "$no_interface_msg" && exit

[[ ! -z $wlName ]] && interface=$wlName || interface=$enName
ip=$(ifconfig $interface | grep 'inet ' | awk '{print $2}')
net_device_ip="$interface $ip"

echo $net_device_ip
