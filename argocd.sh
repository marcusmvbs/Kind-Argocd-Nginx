#!/bin/bash

## Argocd Configuration ##
init_argo_pswd="$(argocd admin initial-password -n argocd | awk 'NR==1 {print $1}')"
kubectl_argo_pods="$(kubectl get pods -n argocd)"
endpoint=$(kubectl get endpoints kubernetes -o=jsonpath='{.subsets[0].addresses[0].ip}:{.subsets[0].ports[0].port}')
endpoint_k="https://$endpoint"
kube_config="$(awk -v endpoint_k8s="$endpoint_k" '/server: /{$2 = endpoint_k8s} 1' ~/.kube/config > temp && mv temp ~/.kube/config)"
kube_fix="$(sed -i 's/\(^ *server:\)/    \1/' ~/.kube/config)"
app_edition="$(sed -i 's#https://kubernetes.default.svc#$endpoint_k#' application.yaml)"
apply_app="$(kubectl apply -f application.yaml)"
config_set="$(kubectl config set-cluster kind-kind --server=$endpoint_k)"
config_context="$(kubectl config set-context --current --namespace=argocd)"
port_forward="$(kubectl port-forward service/argocd-server -n argocd 8080:443 &)"

## Execution ##
sleep 5
$kubectl_argo_pods
sleep 5
$init_argo_pswd
sleep 5
$endpoint
sleep 5
$kube_config
sleep 5
$kube_fix
sleep 5
$app_edition
sleep 5
$apply_app
sleep 5
$config_set
sleep 5
$config_context
# $port_forward
sleep 2

## Argocd App Creation ##
ARGOCD_SERVER="localhost:8080"
GITHUB_REPO="https://github.com/marcusmvbs/argocd-features.git"
argo_login="$(argocd login $ARGOCD_SERVER --username admin --password $init_argo_pswd --insecure)"
argo_add="$(argocd cluster add kind-kind --server=$ARGOCD_SERVER --insecure -y)"
argo_create="$(argocd app create nginx-webapp --repo '$GITHUB_REPO' --path charts/dev/nginx --values values.yaml --dest-namespace webserver --dest-server '$endpoint_k')"
argo_sync="$(argocd app sync nginx-webapp)"

## Execution ##
sleep 50
$argo_login
$argo_add
$argo_create
sleep 10
$argo_sync 