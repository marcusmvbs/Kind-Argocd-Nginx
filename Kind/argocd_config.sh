#!/bin/bash

## Argocd Configuration ##
init_argo_pswd_output=$(argocd admin initial-password -n argocd | awk 'NR==1 {print $1}')
endpoint=$(kubectl get endpoints kubernetes -o=jsonpath='{.subsets[0].addresses[0].ip}:{.subsets[0].ports[0].port}')
endpoint_k="https://$endpoint"

# Update kube config with correct endpoint
awk -v endpoint_k8s="$endpoint_k" '/server: /{$2 = endpoint_k8s} 1' ~/.kube/config > temp && mv temp ~/.kube/config
# Fix kube config indentation
sed -i 's/\(^ *server:\)/    \1/' ~/.kube/config
# Update application.yaml with correct endpoint
sed -i "s#https://kubernetes.default.svc#$endpoint_k#" ../application.yaml

# # Apply configuration changes
kubectl apply -f application.yaml
kubectl config set-cluster kind-kind --server=$endpoint_k
kubectl config set-context --current --namespace=argocd

kubectl port-forward service/argocd-server -n argocd 8080:443 &
sleep 10

## Argocd App Creation ##
ARGOCD_SERVER="localhost:8080"
GITHUB_REPO="https://github.com/marcusmvbs/Kind-Argocd-Nginx.git"

# Login to ArgoCD server
argocd login $ARGOCD_SERVER --username admin --password $init_argo_pswd_output --skip-test-tls --insecure
sleep 5
argocd cluster add kind-kind --server=$ARGOCD_SERVER --insecure -y
sleep 10
argocd app create nginx-webapp --repo $GITHUB_REPO --path charts/dev/nginx-canary --values values.yaml --dest-namespace webserver --dest-server $endpoint_k
sleep 10
argocd app sync nginx-webapp
sleep 10
argocd app get nginx-webapp
sleep 5
kubectl apply -f kind/kubernetes/argocd/argocd-nodeport-svc.yaml
echo -e "\nArgocd login password: $init_argo_pswd_output\n"