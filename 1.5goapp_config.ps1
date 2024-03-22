# Common Variables
$containerName = "kind_container"

# Generate configmap for the app
$create_cm_script = "kubectl create configmap go-script --from-file=kind/kubernetes/go_app/script -n webserver"
$Go_script        = "docker exec -it $containerName sh -c '$create_cm_script'"

# Generate configmap for the app
$create_cm    = "kubectl create configmap go-app --from-file=kind/kubernetes/go_app -n webserver"
$Go_configmap = "docker exec -it $containerName sh -c '$create_cm'"

# Apply app deploy
$deploy_apply   = "kubectl apply -f kind/kubernetes/go_app/deployment.yaml"
$Go_DeployApply = "docker exec -it $containerName sh -c '$deploy_apply'"

# Apply app service
$svc_apply   = "kubectl apply -f kind/kubernetes/go_app/service.yaml"
$Go_SvcApply = "docker exec -it $containerName sh -c '$svc_apply'"

Invoke-Expression -Command $Go_script
Invoke-Expression -Command $Go_configmap
Invoke-Expression -Command $Go_DeployApply
Invoke-Expression -Command $Go_SvcApply