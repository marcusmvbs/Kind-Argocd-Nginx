# Argocd configuration
$containerName = "kind_container"
$Argocd_Script = "docker exec -it $containerName sh -c 'kind/argocd_config.sh'"

Invoke-Expression -Command $Argocd_Script

Write-Output "---`nArgoCD is configured. Execute one of the scripts available to create and sync applications:`n"
Write-Output "'2.1argo_nginx_sync.ps1' for nginx."
Write-Output "'2.2argo_kyverno_sync.ps1' for kyverno.`n"