# Argocd Configuration
$containerName  = "kind_container"
$init_argo_pswd = "argocd admin initial-password -n argocd | awk 'NR==1 {print $1}'"
$endpoint       = "kubectl get endpoints kubernetes -o=jsonpath='{.subsets[0].addresses[0].ip}:{.subsets[0].ports[0].port}'"
$ENDPOINT       = "https://$endpoint"
$kube_config    = "awk -v endpoint=$ENDPOINT '/server: /{$2 = endpoint} 1' ~/.kube/config > temp && mv temp ~/.kube/config"
$kube_fix       = "sed -i 's/\(^ *server:\)/    \1/' ~/.kube/config"
$app_edition    = "sed -i 's#https://kubernetes.default.svc#$ENDPOINT#' application.yaml"
$apply_app      = "kubectl apply -f application.yaml"
$config_set     = "kubectl config set-cluster kind-kind --server=$ENDPOINT"
$config_context = "kubectl config set-context --current --namespace=argocd"

$port_forward   = "kubectl port-forward service/argocd-server -n argocd 8080:443 &"

$INIT_PASSWORD    = "docker exec -it $containerName sh -c '$init_argo_pswd'"
$K8S_Endpoint     = "docker exec -it $containerName sh -c '$endpoint'"
$Edit_KubeConfig  = "docker exec -it $containerName sh -c '$kube_config'"
$Indentation_Fix  = "docker exec -it $containerName sh -c '$kube_fix'"
$Edit_ArgoApp     = "docker exec -it $containerName sh -c '$app_edition'"
$Apply_ArgoApp    = "docker exec -it $containerName sh -c '$apply_app'"
$Set_Cluster      = "docker exec -it $containerName sh -c '$config_set'"
$Set_Context      = "docker exec -it $containerName sh -c '$config_context'"
$Argo_PortForward = "docker exec -it $containerName sh -c '$port_forward'"

# Execution
Start-Sleep -Seconds 50
Invoke-Expression -Command $INIT_PASSWORD
Invoke-Expression -Command $K8S_Endpoint
Invoke-Expression -Command $Edit_KubeConfig
Invoke-Expression -Command $Indentation_Fix
Invoke-Expression -Command $Edit_ArgoApp
Invoke-Expression -Command $Apply_ArgoApp
Invoke-Expression -Command $Set_Cluster
Invoke-Expression -Command $Set_Context
# Invoke-Expression -Command $Argo_PortForward
Start-Sleep -Seconds 2

## Argocd App Creation ##
$ARGOCD_SERVER = "localhost:8080"
$GITHUB_REPO   = "https://github.com/marcusmvbs/argocd-features.git"

$argo_login     = "argocd login $ARGOCD_SERVER --username admin --password $INIT_PASSWORD --insecure"
$argo_add       = "argocd cluster add kind-kind --server=$ARGOCD_SERVER --insecure -y"
$argo_create    = "argocd app create nginx-webapp --repo '$GITHUB_REPO' --path charts/dev/nginx --values values.yaml --dest-namespace webserver --dest-server '$ENDPOINT'"
$argo_sync      = "argocd app sync nginx-webapp"

$Argo_Login      = "docker exec -it $containerName sh -c '$argo_login'"
$Argo_ClusterAdd = "docker exec -it $containerName sh -c '$argo_add'"
$Argo_AppCreate  = "docker exec -it $containerName sh -c '$argo_create'"
$Argo_AppSync    = "docker exec -it $containerName sh -c '$argo_sync'"

# Execution
Start-Sleep -Seconds 50
Invoke-Expression -Command $Argo_Login
Invoke-Expression -Command $Argo_ClusterAdd
Invoke-Expression -Command $Argo_AppCreate
Start-Sleep -Seconds 10
Invoke-Expression -Command $Argo_AppSync

# # helm search repo bitnami/nginx
# # argocd cluster list
# # argocd app get nginx-webapp
# # argocd app delete nginx-webapp