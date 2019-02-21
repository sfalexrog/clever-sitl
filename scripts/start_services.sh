#!/bin/bash

echo "Launching required services in tmux..."

tmux new-session -n 'Status window' -d '/bin/bash /scripts/start_px4_sitl.sh'
tmux setw remain-on-exit on
tmux split-window -v '/bin/bash /scripts/start_gazebo.sh'
tmux split-window -h '/bin/bash /scripts/start_clever.sh'
tmux split-window -v '/bin/bash /scripts/start_gzweb_server.sh'

tmux new-window -n 'User console' '/bin/bash'

echo "Spinning up ssh daemon..."

sudo /usr/sbin/sshd -D &

echo "Launching Butterfly..."

/scripts/start_butterfly.sh


