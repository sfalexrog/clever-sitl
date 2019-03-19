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

echo -e "\n\nServices launched!\n * Open http://localhost:8080 for a list of image topics\n * Open http://localhost:8081 for gzweb real-time visualization\n * Open http://localhost:57575 for Butterfly terminal\n"

/scripts/start_butterfly.sh

