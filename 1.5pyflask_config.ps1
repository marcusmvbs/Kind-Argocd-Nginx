# Common Variables
$containerName = "kind_container"

# Apply Python app deploy
$deploy_apply = "kubectl apply -f kind/kubernetes/go_app/deployment.yaml"
$Flask_deploy = "docker exec -it $containerName sh -c '$deploy_apply'"
Invoke-Expression -Command $Flask_deploy

# Apply Python app services
$svc_apply = "kubectl apply -f kind/kubernetes/go_app/service.yaml"
$Flask_svc = "docker exec -it $containerName sh -c '$svc_apply'"
Invoke-Expression -Command $Flask_svc