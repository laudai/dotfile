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

#tmux select-layout -t workspace main-horizontal

tmux new-window -t workspace -n show_htop 
tmux send-keys -t workspace:2 "htop" C-m

#I meet some problem,bcz I had set window-index base 1
#but I get index 0
#In somdeday will fix 
tmux attach -t workspace
tmux select-window -t workspace:1.1 
