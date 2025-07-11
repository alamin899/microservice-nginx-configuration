#!/bin/bash

set -e

IMAGE_NAME="nginx-gateway"
CONTAINER_NAME="nginx-gateway"
HOST_PORT=8099
CONTAINER_PORT=80
CONFIG_PATH="$(pwd)/nginx.conf"

echo "📦 Building Docker image..."
docker build -t $IMAGE_NAME .

# Stop and remove old container if exists
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "🛑 Stopping and removing existing container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

echo "🚀 Running new container..."
docker run -d --name $CONTAINER_NAME \
      -p $HOST_PORT:$CONTAINER_PORT \
      -v $CONFIG_PATH:/etc/nginx/nginx.conf:ro \
      $IMAGE_NAME

echo "✅ NGINX Gateway is running at http://localhost:$HOST_PORT"
