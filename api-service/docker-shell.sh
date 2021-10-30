#!/bin/bash

# exit immediately if a command exits with a non-zero status
set -e

# Define some environment variables
# Automatic export to the environment of subsequently executed commands
# source: the command 'help export' run in Terminal
# NOTE: Defining global VARs to use, mainly for paths to easily grab
export IMAGE_NAME="mushroom-app-api-service"
export BASE_DIR=$(pwd)
export PERSISTENT_DIR=$(pwd)/../persistent-folder/
export SECRETS_DIR=$(pwd)/../secrets/

# Build the image based on the Dockerfile
docker build -t $IMAGE_NAME -f Dockerfile .

# Run the container
# --mount: Attach a filesystem mount to the container
# -p: Publish a container's port(s) to the host (host_port: container_port) (source: https://dockerlabs.collabnix.com/intermediate/networking/ExposingContainerPort.html)
# NOTE: We mount all the local directories we want the actual container to have access to
# Create 2 containers -> DEV 1 or 0 is Dev or production
docker run --rm --name $IMAGE_NAME -ti \
--mount type=bind,source="$BASE_DIR",target=/app \
--mount type=bind,source="$PERSISTENT_DIR",target=/persistent \
--mount type=bind,source="$SECRETS_DIR",target=/secrets \
-p 9000:9000 \
-e DEV=1 $IMAGE_NAME