$containerName = "kind_container"

$Argocd_Script = "docker exec -it $containerName sh -c 'kind/kubernetes/argocd/argocd_config.sh'"

Invoke-Expression -Command $Argocd_Script
Write-Output "---`nArgocd is configured - nginx webapp created and synced."
Write-Output "Argocd nodeport service enabled - https://localhost:30080`n"