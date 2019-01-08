#!/bin/bash

# TODO: add a more comprehensive script to pass through our GUI

docker run -p 6080:6080 -p 14556:14556 -p 14557:14557 -p 11311:11311 sfalexrog/clever-sitl:latest-gui

