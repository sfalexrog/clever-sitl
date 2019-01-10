#!/bin/bash

echo "Building base image"

docker build --tag sfalexrog/clever-sitl:latest .

echo "Building native GUI image"

docker build --tag sfalexrog/clever-sitl:native-gui native-gui/

