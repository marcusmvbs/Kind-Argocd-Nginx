### Kubernetes Dashboard NodePort Service ###
$containerName  = "kind_container"
$create_sa      = "kubectl apply -f /kind/kubernetes/dashboard/service-account.yaml"
$kubectl_secret = "kubectl apply -f /kind/kubernetes/dashboard/sa-secret.yaml"
$nodeport_svc   = "kubectl apply -f /kind/kubernetes/dashboard/nodeport-service.yaml"
$kubectl_svc    = "kubectl get svc -n kubernetes-dashboard"
$get_secret     = "kubectl describe secret k8s-dashboard-token-secret -n kubernetes-dashboard"

$Create_SvcAcc      = "docker exec -it $containerName sh -c '$create_sa'"
$Secret_Token       = "docker exec -it $containerName sh -c '$kubectl_secret'"
$Apply_Svc          = "docker exec -it $containerName sh -c '$nodeport_svc'"
$Get_Svc            = "docker exec -it $containerName sh -c '$kubectl_svc'"
$Get_Token          = "docker exec -it $containerName sh -c '$get_secret'"

Invoke-Expression -Command $Create_SvcAcc
Start-Sleep -Seconds 2
Invoke-Expression -Command $Secret_Token
Start-Sleep -Seconds 2
Invoke-Expression -Command $Apply_Svc
Start-Sleep -Seconds 2
Invoke-Expression -Command $Get_Svc
Start-Sleep -Seconds 2
Invoke-Expression -Command $Get_Token

Write-Output "`nDashboard Nodeport service enabled: https://localhost:30500`n"
Write-Output "Copy bearer token to access kubernetes dashboard on browser."