$containerName = "kind_container"
$nodeport_svc  = "kubectl apply -f kind/kubernetes/prometheus/grafana-nodeport-svc.yaml"
# kubectl get svc prometheus-grafana -n monitoring -o yaml > grafana-nodeport-svc.yaml

# $grafana_creds = "$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data}')"
# admin_username=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 --decode)
# admin_password=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 --decode)
# echo $admin_username {admin}
# echo $admin_password {promoperator}

$Grafana_config = "docker exec -it $containerName sh -c '$nodeport_svc'"
# $Grafana_keys   = "docker exec -it $containerName sh -c '$grafana_creds'"

Invoke-Expression -Command $Grafana_config
# Invoke-Expression -Command $Grafana_keys

Write-Output "Grafana nodeport service enabled - http://localhost:30003 `n"