# Argocd create nignx server and syncronize with Github repo
$containerName = "kind_container"
$Argocd_Script   = "docker exec -it $containerName sh -c 'kind/argo_nginx_sync.sh'"

Invoke-Expression -Command $Argocd_Script