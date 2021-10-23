#!/bin/bash

# exit immediately if a command exits with a non-zero status
set -e

# Define some environment variables
# Automatic export to the environment of subsequently executed commands
# source: the command 'help export' run in Terminal
# NOTE: ENV VARS we set before runing the container so it can use them
export IMAGE_NAME="mushroom-app-frontend-simple"
export BASE_DIR=$(pwd)

# NOTE: Build the image based on the Dockerfile
docker build -t $IMAGE_NAME -f Dockerfile .

# Run the container
# --mount: Attach a filesystem mount to the container
# -p: Publish a container's port(s) to the host (host_port: container_port) (source: https://dockerlabs.collabnix.com/intermediate/networking/ExposingContainerPort.html)
# NOTE: Instead of having to run this very long command each time we put it into this script
docker run --rm --name $IMAGE_NAME -ti \
--mount type=bind,source="$BASE_DIR",target=/app \
-p 8080:8080 $IMAGE_NAME
