#tmux has-session -t workspace
#if [echo $? != 0]
#then
#fi

tmux new-session -s workspace -n win1 -d

#tmux send-keys -t development "cd ~/devproject" C-m

#tmux send-keys -t development "vim" C-m

tmux split-window -t workspace -h

tmux split-window -t workspace -v -p 40
#-p percentage

tmux new-window -t workspace -n win2 
tmux send-keys -t workspace:2 "python" C-m

tmux new-window -t workspace -n win3
tmux send-keys -t workspace:3 "htop" C-m

#tmux select-window -t workspace:1.1
#I meet some problem,bcz I had set window-index base 1
#but I get index 0
#In somdeday will fix 

tmux select-window -t workspace:1
#select-window can shorten to selectw
tmux select-pane -R

#tmux select-layout -t workspace main-horizontal
tmux attach -t workspace
