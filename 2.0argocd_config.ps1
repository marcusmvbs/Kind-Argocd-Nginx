# Argocd configuration
$containerName = "kind_container"
$Argocd_Script = "docker exec -it $containerName sh -c 'kind/argocd_config.sh'"

Invoke-Expression -Command $Argocd_Script

Write-Output "---`nArgoCD is configured. Apps created and synced.`n"