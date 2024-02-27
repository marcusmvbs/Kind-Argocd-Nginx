#!/bin/bash

# Source the file containing the token
source .gitlab_access_token.txt

# Set your ArgoCD server address
ARGOCD_SERVER="https://localhost:8080"

# Login to ArgoCD using the personal access token
argocd login --insecure --grpc-web --username "$USER_TOKEN" --password "$PASSWORD_TOKEN" "$ARGOCD_SERVER"

# Now you can perform various operations with ArgoCD using the CLI tool
argocd app list

# argocd app get <app-name>
