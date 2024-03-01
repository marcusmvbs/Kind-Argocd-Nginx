#!/bin/bash

## Argocd Configuration ##
init_argo_pswd_output=$(argocd admin initial-password -n argocd | awk 'NR==1 {print $1}')
endpoint=$(kubectl get endpoints kubernetes -o=jsonpath='{.subsets[0].addresses[0].ip}:{.subsets[0].ports[0].port}')
endpoint_k="https://$endpoint"
echo "Initial ArgoCD Password: $init_argo_pswd_output"
echo "Endpoint for Kubernetes: $endpoint_k"

# Update kube config with correct endpoint
awk -v endpoint_k8s="$endpoint_k" '/server: /{$2 = endpoint_k8s} 1' ~/.kube/config > temp && mv temp ~/.kube/config
# Fix kube config indentation
sed -i 's/\(^ *server:\)/    \1/' ~/.kube/config
# Update application.yaml with correct endpoint
sed -i "s#https://kubernetes.default.svc#$endpoint_k#" ../application.yaml

# # Apply configuration changes
apply_app_output=$(kubectl apply -f application.yaml)
config_set_output=$(kubectl config set-cluster kind-kind --server=$endpoint_k)
config_context_output=$(kubectl config set-context --current --namespace=argocd)
# port_forward="$(kubectl port-forward service/argocd-server -n argocd 8080:443 &)"