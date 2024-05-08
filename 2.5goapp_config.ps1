# Common Variables
$containerName = "kind_container"

# Generate configmap for the script to build goapp
$Create_cm_script = "kubectl create configmap go-script --from-file=kind/kubernetes/go_app/script -n webserver"
$Go_script        = "docker exec -it $containerName sh -c '$Create_cm_script'"

# Generate configmap with go dependencies for the app
$Create_cm    = "kubectl create configmap go-app --from-file=kind/kubernetes/go_app/app -n webserver"
$Go_configmap = "docker exec -it $containerName sh -c '$Create_cm'"

# Apply app deployment
$Deploy_apply   = "kubectl apply -f kind/kubernetes/go_app/templates/deployment.yaml"
$Go_deployApply = "docker exec -it $containerName sh -c '$Deploy_apply'"

# Apply app service
$Svc_apply   = "kubectl apply -f kind/kubernetes/go_app/templates/service.yaml"
$Go_svcApply = "docker exec -it $containerName sh -c '$Svc_apply'"

Invoke-Expression -Command $Go_script
Invoke-Expression -Command $Go_configmap
Invoke-Expression -Command $Go_deployApply
Invoke-Expression -Command $Go_svcApply

Write-Output "`nIt might take 240s to start fiber server on http://localhost:30181`n"