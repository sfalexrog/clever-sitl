#!/bin/bash

echo "Building base image"

docker build --tag sfalexrog/clever-sitl:latest .

echo "Building VNC-based image"

docker build --tag sfalexrog/clever-sitl:vnc-gui gui/

