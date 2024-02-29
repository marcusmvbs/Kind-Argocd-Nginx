#!/bin/bash

# # Exec cluster and run following commands
# vim application.yaml ----> Change https://kubernetes.default.svc to k8s endpoint, e.g.:https://172.24.0.4:6443
# kubectl apply -f application.yaml
# kubectl config set-cluster kind-kind --server=https://172.24.0.4:6443 
# kubectl config set-context --current --namespace=argocd
# argocd admin initial-password -n argocd
# kubectl port-forward service/argocd-server -n argocd 8080:443 &
# argocd login localhost:8080 --username admin --password <initial-password>
# argocd cluster add kind-kind --server=localhost:8080 --insecure
# argocd app create nginx-webapp --repo https://github.com/marcusmvbs/argocd-features.git --path charts/dev/nginx --values values.yaml --dest-namespace webserver --dest-server https://172.24.0.4:6443
# argocd app sync nginx-webapp

## ARGOCD GITOPS - Config ## https://argo-cd.readthedocs.io/en/stable/getting_started/

# Collect the Kubernetes endpoint using kubectl get endpoints and replace the server config in the kubeconfig file
ENDPOINT=$(kubectl get endpoints kubernetes -o=jsonpath='{.subsets[0].addresses[0].ip}')
awk -v endpoint="$ENDPOINT" '/server: /{$2 = "https://" endpoint} 1' ~/.kube/config > temp && mv temp ~/.kube/config
# vim ~/.kube/config

kubectl apply -f application.yaml
# Set the cluster configuration
kubectl config set-cluster kind-kind --server=$K8S_ENDPOINT
# Set the context namespace
kubectl config set-context --current --namespace=argocd
# Generate initial password for ArgoCD admin
initialPassword=$(argocd admin initial-password -n argocd)
# Port forward ArgoCD server and keep it running
nohup kubectl port-forward service/argocd-server -n argocd 8080:443 > port-forward.log 2>&1

# Log in to ArgoCD
argocd login localhost:8080 --username admin --password "$initialPassword" --insecure
# Add the cluster to ArgoCD
argocd cluster add kind-kind --server=localhost:8080 --insecure
# Create and sync the application
GITHUB_REPO=https://github.com/marcusmvbs/argocd-features.git
argocd app create nginx-webapp --repo GITHUB_REPO --path charts/dev/nginx --values values.yaml --dest-namespace webserver --dest-server $K8S_ENDPOINT
argocd app sync nginx-webapp

# # helm search repo bitnami/nginx
# # argocd cluster list
# # argocd app get nginx-webapp
# # argocd app delete nginx-webapp