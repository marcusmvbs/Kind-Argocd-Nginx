$containerName = "kind_container"
$nodeport_svc  = "kubectl apply -f kind/kubernetes/prometheus/grafana-nodeport-svc.yaml"

$Grafana_config = "docker exec -it $containerName sh -c '$nodeport_svc'"

Invoke-Expression -Command $Grafana_config
Write-Output "Grafana nodeport service enabled - http://localhost:30003 `n"