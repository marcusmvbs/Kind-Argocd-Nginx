$containerName      = "kind_container"
$service_account    = "kubectl apply -f kind/kubernetes/prometheus/serviceaccount.yaml"
$additional_conf    = "kubectl apply -f kind/kubernetes/prometheus/secret.yaml"
$kubectl_prom_oper  = "kubectl apply -f kind/kubernetes/prometheus/prometheus.yaml"
$grafana_np_svc     = "kubectl apply -f kind/kubernetes/prometheus/grafana-service.yaml"
$kubectl_delete_fix = "kubectl delete service/prometheus-operated -n monitoring"
$prometheus_np_svc  = "kubectl apply -f kind/kubernetes/prometheus/prometheus-service.yaml"
$apply_deploy       = "kubectl apply -f kind/kubernetes/exporter/deployment.yaml"
$apply_service      = "kubectl apply -f kind/kubernetes/exporter/service.yaml"
$apply_probe        = "kubectl apply -f kind/kubernetes/probe.yaml"

# admin_username=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 --decode)
# admin_password=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 --decode)
# echo $admin_username $admin_password -> "admin" "prom-operator"

$Prometheus_sa       = "docker exec -it $containerName sh -c '$service_account'"
$Scrape_config       = "docker exec -it $containerName sh -c '$additional_conf'"
$Prometheus_operator = "docker exec -it $containerName sh -c '$kubectl_prom_oper'"
$Grafana_svc         = "docker exec -it $containerName sh -c '$grafana_np_svc'"
$Delete_svc          = "docker exec -it $containerName sh -c '$kubectl_delete_fix'"
$Create_svc          = "docker exec -it $containerName sh -c '$prometheus_np_svc'"
$Exporter_Deploy     = "docker exec -it $containerName sh -c '$apply_deploy'"
$Exporter_Svc        = "docker exec -it $containerName sh -c '$apply_service'"
$Exporter_Probe      = "docker exec -it $containerName sh -c '$apply_probe'"

Invoke-Expression -Command $Prometheus_sa
Start-Sleep -Seconds 5
Invoke-Expression -Command $Scrape_config
Start-Sleep -Seconds 5
Invoke-Expression -Command $Prometheus_operator
Start-Sleep -Seconds 5
Invoke-Expression -Command $Grafana_svc
Start-Sleep -Seconds 5
Invoke-Expression -Command $Delete_svc
Start-Sleep -Seconds 5
Invoke-Expression -Command $Create_svc
Start-Sleep -Seconds 5
Invoke-Expression -Command $Exporter_Deploy
Start-Sleep -Seconds 5
Invoke-Expression -Command $Exporter_Svc
# Start-Sleep -Seconds 5
# Invoke-Expression -Command $Exporter_Probe
Start-Sleep -Seconds 5
Invoke-Expression -Command $Create_svc

# Get Service
$kubectl_svc = "kubectl get po,svc -n monitoring"
$Get_Svc     = "docker exec -it $containerName sh -c '$kubectl_svc'"
Invoke-Expression -Command $Get_Svc

Write-Output "`nGrafana nodeport service -> http://localhost:30003"
Write-Output "Prometheus nodeport service -> http://localhost:32000`n"