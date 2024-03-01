# Argocd configuration
$containerName = "kind_container"
$Argocd_Script = "docker exec -it $containerName sh -c 'kind/argocd_config.sh'"

Invoke-Expression -Command $Argocd_Script