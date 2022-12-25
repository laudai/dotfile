#!/usr/bin/env bash
# Author : laudai


echo "Change to sudo user to use the utilities."
read -n 1 -r -s -p "Press any key to continue."

#sudo -s
# you need to test for the sudo without interactly shell
sudo -s

(which iftop >/dev/null) && sudo iftop || echo "you need install iftop before"


# TODO for the en or wl device which has the net ip first
sudo iftop -i
sudo tcpdump
glances
htop
top # without check the program
vmstat -S M 5 # the number need be set if user need change the default number
mtr www.aws.amazon.com
watch -n 2 -d free -lm

# TODO need to check the number variable is number or not
