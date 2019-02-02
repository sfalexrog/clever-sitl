#!/bin/bash

# Bash won't read my .profile :(

source /home/$ROSUSER/.profile
source /home/$ROSUSER/.bashrc

cd /home/$ROSUSER/gzweb
npm start -p 8081
