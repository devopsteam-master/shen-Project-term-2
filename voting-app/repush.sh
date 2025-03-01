#!/bin/bash

# Set your Docker Hub username
DOCKER_USERNAME="h0x3ein"

# Define image names
VOTE_IMAGE="$DOCKER_USERNAME/examplevotingapp_vote"
WORKER_IMAGE="$DOCKER_USERNAME/examplevotingapp_worker"
RESULT_IMAGE="$DOCKER_USERNAME/examplevotingapp_result"

# Prompt user to choose which image to push
echo "Select which Docker image to push:"
echo "1. Vote"
echo "2. Worker"
echo "3. Result"
echo "4. All"
read -p "Enter your choice (1-4): " choice

case $choice in
  1)
    echo "Building and pushing the vote app Docker image..."
    docker build -t $VOTE_IMAGE ./vote/
    docker push $VOTE_IMAGE
    ;;
  2)
    echo "Building and pushing the worker app Docker image..."
    docker build -t $WORKER_IMAGE ./worker/
    docker push $WORKER_IMAGE
    ;;
  3)
    echo "Building and pushing the result app Docker image..."
    docker build -t $RESULT_IMAGE ./result/
    docker push $RESULT_IMAGE
    ;;
  4)
    echo "Building and pushing all Docker images..."
    docker build -t $VOTE_IMAGE ./vote/
    docker push $VOTE_IMAGE

    docker build -t $WORKER_IMAGE ./worker/
    docker push $WORKER_IMAGE

    docker build -t $RESULT_IMAGE ./result/
    docker push $RESULT_IMAGE
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

echo "Done! Docker images have been pushed to Docker Hub."
