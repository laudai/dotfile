#!/usr/bin/env bash
# Author : laudai

# source the color if file exists
test -e "$HOME/.dotfile/color.txt" && source "$HOME/.dotfile/color.txt"


#curl checkip.amazonaws.com

# check vpn enabled or not
ip a | grep -E "surfshark" >/dev/null
VPN_ENABLED=$?
if [[ $VPN_ENABLED -eq 0 ]]; then
	echo -e "VPN is ${BOLD_GREEN}enabled${RESET}."
else
	echo -e "VPN is ${BOLD_RED}not enabled${RESET}."
fi
echo


echo "My ipv4 address is:"
ipv4_respone=$(curl -4 ifconfig.co 2>/dev/null )
if [[ ! -z $ipv4_respone ]]; then
	echo -e "${UNDERLINE_WHITE}${ipv4_respone}${RESET}"
else
	echo "Maybe respone timeout."
fi
echo

echo "My ipv6 address is:"
ipv6_respone=$(curl -6 ifconfig.co 2>/dev/null )
if [[ ! -z $ipv6_respone ]]; then
	echo -e "${UNDERLINE_WHITE}${ipv6_respone}${RESET}"
else
	echo "Maybe respone timeout."
fi
