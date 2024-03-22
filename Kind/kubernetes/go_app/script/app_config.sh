#!/bin/bash

# kubectl exec -it pod-name -n webserver -- sh
# cp /app_config/script/app_config.sh /tmp/app_config.sh
# cp -r /app_config/ /tmp/

cd /tmp/app_config/
# Download module dependencies
go mod download
sleep 2

# Verify module dependencies
go mod verify
sleep 2

# Build the Go application - it takes 240s
go build -o /myapp main.go
sleep 2

# Start the built application
/myapp