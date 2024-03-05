#!/bin/bash
kubectl config set-context --current --namespace=webserver

# Get list of Nginx pods
nginx_pods=$(kubectl get pods -l app=nginx-canary -n webserver --no-headers | awk '{print $1}')

# File to copy
index="../nginx/html/index.html"

# Destination directory in the pods
destination_dir_index="/usr/share/nginx/html"

# Loop through each Nginx pod
for pod_name in $nginx_pods; do
    kubectl cp "$index" "webserver/$pod_name:$destination_dir_index"
done