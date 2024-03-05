#!/bin/bash
kubectl config set-context --current --namespace=webserver

# Get list of Nginx pods
nginx_pods=$(kubectl get pods -l app=nginx-canary -n webserver --no-headers | awk '{print $1}')

# File to copy
file_to_copy="nginx/html/index.html"

# Destination directory in the pods
destination_directory="/usr/share/nginx/html/"

# Loop through each Nginx pod
for pod_name in $nginx_pods; do
    # Copy the file to the pod
    kubectl cp "$file_to_copy" "webserver/$pod_name:$destination_directory"
done
