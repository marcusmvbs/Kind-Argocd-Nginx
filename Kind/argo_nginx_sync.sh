# Sourcing
. ./argocd_config.sh

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