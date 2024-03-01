# Argocd configuration
$containerName = "kind_container"
$Argocd_Script   = "docker exec -it $containerName sh -c './argocd/argocd_config.sh'"

Invoke-Expression -Command $Argocd_Script