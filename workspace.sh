#tmux has-session -t workspace
#if [echo $? != 0]
#then
#fi


#tmux new-session -s servers "ssh login@server"
# if u not use send-keys , u don't need to use C-m

tmux new-session -s workspace -n win1 -d

#tmux send-keys -t development "cd ~/devproject" C-m
#tmux send-keys -t development "vim" C-m

tmux split-window -t workspace -h "python3"

tmux split-window -t workspace -v -p 40 #-p percentage
tmux send-keys -t workspace:1.3 "fortune | cowsay | lolcat" C-m
#tmux send-keys -t workspace:1.3 "cowsay Hi welcom to linux" C-m

tmux new-window -t workspace -n win2 "python3"

tmux new-window -t workspace -n win3 "htop"

tmux new-window -t workspace -n win4
tmux send-keys -t workspace:4 "nmcli dev wifi list" C-m

tmux new-window -t workspace -n win5
tmux send-keys -t workspace:5 "cmatrix" C-m
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
