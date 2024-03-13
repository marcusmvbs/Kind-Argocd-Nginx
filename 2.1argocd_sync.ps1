$containerName = "kind_container"
$kubectl_svc   = "kubectl get svc -n argocd"

$Argocd_Script = "docker exec -it $containerName sh -c './kind/kubernetes/argocd/argocd_config.sh'"
$Get_Svc       = "docker exec -it $containerName sh -c '$kubectl_svc'"

Invoke-Expression -Command $Argocd_Script
Invoke-Expression -Command $Get_Svc

Write-Output "---`nArgocd is configured - nginx webapp created and synced."
Write-Output "Argocd nodeport service enabled - https://localhost:30080`n"