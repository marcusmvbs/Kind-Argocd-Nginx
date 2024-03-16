$containerName      = "kind_container"
$service_account    = "kubectl apply -f kind/kubernetes/prometheus/serviceaccount.yaml"
$grafana_np_svc     = "kubectl apply -f kind/kubernetes/prometheus/grafana-service.yaml"
$kubectl_delete_fix = "kubectl delete service/prometheus-operated -n monitoring"
$prometheus_np_svc  = "kubectl apply -f kind/kubernetes/prometheus/prometheus-service.yaml"
$kubectl_prom_oper  = "kubectl apply -f kind/kubernetes/prometheus/prometheus.yaml"

# admin_username=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 --decode)
# admin_password=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 --decode)
# echo $admin_username $admin_password -> "admin" "prom-operator"

$Prometheus_sa       = "docker exec -it $containerName sh -c '$service_account'"
$Grafana_svc         = "docker exec -it $containerName sh -c '$grafana_np_svc'"
$Prometheus_svc      = "docker exec -it $containerName sh -c '$prometheus_np_svc'"
$Prometheus_operator = "docker exec -it $containerName sh -c '$kubectl_prom_oper'"

Invoke-Expression -Command $Prometheus_sa
Invoke-Expression -Command $Grafana_svc
# Start-Sleep -Seconds 10
# Invoke-Expression -Command "docker exec -it $containerName sh -c '$kubectl_delete_fix'"
# Start-Sleep -Seconds 10
# Invoke-Expression -Command $Prometheus_svc
# Start-Sleep -Seconds 10
Invoke-Expression -Command $Prometheus_operator

$kubectl_svc = "kubectl get svc -A"
$Get_Svc     = "docker exec -it $containerName sh -c '$kubectl_svc'"
Invoke-Expression -Command $Get_Svc

Write-Output "Grafana nodeport service -> http://localhost:30003"
Write-Output "Prometheus nodeport service -> http://localhost:32000 `n"