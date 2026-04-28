if [[ "$TERM" != "screen-256color" ]]
then
	tmux attach-session -t "$USER" || tmux new-session -s "$USER"
fi
