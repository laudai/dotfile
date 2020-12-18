
#tmux new-session -s servers "ssh login@server"
# if u not use send-keys , u don't need to use C-m

your_ip=$(curl ipinfo.io/ip)

if ! tmux has-session -t workspace;then
	tmux new-session -s workspace -n win1 -d

	#tmux send-keys -t development "cd ~/devproject" C-m
	#tmux send-keys -t development "vim" C-m

	tmux split-window -t workspace -h
	tmux send-keys -t workspace "ipython3" C-m


	tmux split-window -t workspace -v -p 25 #p percentage
	tmux clock-mode -t workspace:1.3

	tmux new-window -t workspace -n win2 "python3"

	tmux new-window -t workspace -n win3
	tmux send-keys -t workspace:3 "echo Your LAN IP is:'$your_ip'" C-m
	tmux send-keys -t workspace:3 "sockstat" C-m
	tmux send-keys -t workspace:3 "speedtest-cli" C-m
	tmux send-keys -t workspace:3 "htop" C-m

	tmux new-window -t workspace -n win4 "glances"


	tmux new-window -t workspace -n win5
	tmux send-keys -t workspace:5 "mc" C-m

	tmux new-window -t workspace -n win6
	tmux send-keys -t workspace:6 "screenfetch" C-m
	tmux send-keys -t workspace:6 "nmcli dev wifi list" C-m
	tmux split-window -t workspace -h -p 30
	tmux send-keys -t workspace:6.2 "fortune | cowsay | lolcat" C-m
	#tmux send-keys -t workspace:6.2 "cowsay Hi welcom to linux" C-m
	tmux split-window -t workspace:6.2 -v -p 25 "cmatrix"

	#tmux select-window -t workspace:1.1
	#I meet some problem,bcz I had set window-index base 1
	#but I get index 0
	#In somdeday will fix

	tmux send-keys -t workspace:1.1 "vim" C-m
	tmux select-window -t workspace:1
	#select-window can shorten to selectw
	tmux select-pane -R

	#tmux select-layout -t workspace main-horizontal
	tmux attach -t workspace
fi
exec tmux attach -t workspace
