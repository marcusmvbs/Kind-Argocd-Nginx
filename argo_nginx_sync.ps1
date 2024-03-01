# Argocd create application and syncronize with Github repo
$containerName = "kind_container"
$Argocd_Script   = "docker exec -it $containerName sh -c './argocd/argo_nginx_sync.sh'"

Invoke-Expression -Command $Argocd_Script