#!/bin/bash

# Define the tmux session name
SESSION_NAME="f1tv_session"

# Check if the tmux session already exists. If it does, exit.
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
  echo "A tmux session named '$SESSION_NAME' is already running."
  exit 1
fi

# Create a new tmux session using the defined session name
tmux new-session -d -s $SESSION_NAME

# In the first pane, fetch and print the location of the codespace
tmux send-keys -t $SESSION_NAME 'echo -e "\n\033[1;32m***** Codespace Location: $(gh api /user/codespaces/$CODESPACE_NAME --jq .location) *****\033[0m\n"' C-m

# In the first pane, run the Go application
tmux send-keys -t $SESSION_NAME 'go run .' C-m

# Split the window horizontally and run iftop in the new pane
tmux split-window -h
tmux send-keys -t $SESSION_NAME 'sudo iftop' C-m

# Attach to the tmux session to bring it into the foreground
tmux attach-session -t $SESSION_NAME
