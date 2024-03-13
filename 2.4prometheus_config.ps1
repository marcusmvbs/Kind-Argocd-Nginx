$containerName     = "kind_container"
$grafana_np_svc    = "kubectl apply -f kind/kubernetes/prometheus/grafana-service.yaml"
$prometheus_np_svc = "kubectl apply -f kind/kubernetes/prometheus/prometheus-service.yaml"

# admin_username=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 --decode)
# admin_password=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 --decode)
# echo $admin_username $admin_password -> "admin" "prom-operator"

$Grafana_config    = "docker exec -it $containerName sh -c '$grafana_np_svc'"
$Prometheus_config = "docker exec -it $containerName sh -c '$prometheus_np_svc'"

Invoke-Expression -Command $Grafana_config
Invoke-Expression -Command $Prometheus_config

Write-Output "Grafana nodeport service -> http://localhost:30003"
Write-Output "Prometheus nodeport service -> http://localhost:32000 `n"