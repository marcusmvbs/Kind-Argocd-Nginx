### Kubernetes Dashboard NodePort Service ###
$containerName  = "kind_container"
$create_sa      = "kubectl create serviceaccount dashboard-sa --namespace=kubernetes-dashboard"
$nodeport_svc   = "kubectl apply -f /kind/kubernetes/dashboard/dashboard-nodeport-svc.yaml"
$kubectl_svc    = "kubectl get svc -n kubernetes-dashboard"
$cluster_role   = "kubectl apply -f /kind/kubernetes/dashboard/cluster-role.yaml"
$cluster_rb     = "kubectl apply -f /kind/kubernetes/dashboard/cluster-rb.yaml"
$kubectl_secret = "kubectl apply -f /kind/kubernetes/dashboard/dashboard-sa-secret.yaml"
$get_secret     = "kubectl describe secret k8s-dashboard-token-secret -n kubernetes-dashboard"

$Svc_Acc            = "docker exec -it $containerName sh -c '$create_sa'"
$Apply_Svc          = "docker exec -it $containerName sh -c '$nodeport_svc'"
$Get_Svc            = "docker exec -it $containerName sh -c '$kubectl_svc'"
$Apply_cRole        = "docker exec -it $containerName sh -c '$cluster_role'"
$Apply_cRoleBinding = "docker exec -it $containerName sh -c '$cluster_rb'"
$Secret_Token       = "docker exec -it $containerName sh -c '$kubectl_secret'"
$Get_Token          = "docker exec -it $containerName sh -c '$get_secret'"

Invoke-Expression -Command $Svc_Acc
Start-Sleep -Seconds 2
Invoke-Expression -Command $Apply_Svc
Start-Sleep -Seconds 2
Invoke-Expression -Command $Get_Svc
Start-Sleep -Seconds 2
Invoke-Expression -Command $Apply_cRole
Start-Sleep -Seconds 2
Invoke-Expression -Command $Apply_cRoleBinding
Start-Sleep -Seconds 2
Invoke-Expression -Command $Secret_Token
Start-Sleep -Seconds 2
Invoke-Expression -Command $Get_Token

Write-Output "`nDashboard Nodeport service enabled: https://localhost:30500`n"
Write-Output "Copy bearer token to access kubernetes dashboard on browser."