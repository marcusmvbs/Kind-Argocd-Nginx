# Argocd configuration
$containerName = "kind_container"
$nginx_pods    = "kubectl get pods -n webserver"

$Argocd_Script = "docker exec -it $containerName sh -c 'kind/argocd_config.sh'"
$Nginx_Pods    = "docker exec -it $containerName sh -c '$nginx_pods'"

Invoke-Expression -Command $Argocd_Script
Invoke-Expression -Command $Nginx_Pods
Write-Output "---`nArgoCD is configured. Nginx app created and synced.`n"