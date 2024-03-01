#!/bin/bash

## Argocd Configuration ##
kubectl_argo_pods=$(kubectl get pods -n argocd)
init_argo_pswd=$(argocd admin initial-password -n argocd | awk 'NR==1 {print $1}')
endpoint=$(kubectl get endpoints kubernetes -o=jsonpath='{.subsets[0].addresses[0].ip}:{.subsets[0].ports[0].port}')
endpoint_k="https://$endpoint"

# Update kube config with correct endpoint
awk -v endpoint_k8s="$endpoint_k" '/server: /{$2 = endpoint_k8s} 1' ~/.kube/config > temp && mv temp ~/.kube/config

# Fix kube config indentation
sed -i 's/\(^ *server:\)/    \1/' ~/.kube/config

# Update application.yaml with correct endpoint
sed -i "s#https://kubernetes.default.svc#$endpoint_k#" ../application.yaml

# Apply configuration changes
kubectl_argo_pods_output=$(eval "$kubectl_argo_pods")
init_argo_pswd_output=$(eval "$init_argo_pswd")
apply_app_output=$(eval "$apply_app")
config_set_output=$(eval "$config_set")
config_context_output=$(eval "$config_context")

## Output ##
echo "ArgoCD Pods:"
echo "$kubectl_argo_pods_output"

echo "Initial ArgoCD Password:"
echo "$init_argo_pswd_output"

echo "Endpoint for Kubernetes:"
echo "$endpoint"

echo "ArgoCD app creation:"
echo "$apply_app_output"

echo "Kubernetes set-cluster kind-kind:"
echo "$config_set_output"

echo "Kubernetes set current context at namespace argocd"
echo "$config_context_output"

# Uncomment to start port forwarding
#kubectl port-forward service/argocd-server -n argocd 8080:443 &