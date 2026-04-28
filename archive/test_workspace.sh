tmux new-session -s development -n editor -d

tmux send-keys -t development "cd ~/devproject" C-m

tmux send-keys -t development "vim" C-m

tmux split-window -v -p 10 -t development
#-p percentage

tmux select-layout -t development main-horizontal

tmux send-keys -t development:1.2 "cd ~/devproject" C-m

tmux new-window -n console -t development
tmux send-keys -t development:2 "cd ~/deveproject" C-m

tmux select-window -t development:1
tmux attach -t development

