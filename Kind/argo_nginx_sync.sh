## Argocd App Creation ##
ARGOCD_SERVER="localhost:8080"
GITHUB_REPO="https://github.com/marcusmvbs/argocd-features.git"

# Login to ArgoCD server
argocd login $ARGOCD_SERVER --username admin --password $init_argo_pswd_output --skip-test-tls --insecure
sleep 5
argocd cluster add kind-kind --server=$ARGOCD_SERVER --insecure -y
sleep 5
argocd app create nginx-webapp --repo $GITHUB_REPO --path charts/dev/nginx --values values.yaml --dest-namespace webserver --dest-server $endpoint_k
sleep 5
argocd app sync nginx-webapp