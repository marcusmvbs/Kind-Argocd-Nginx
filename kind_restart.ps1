# Common Variables
$imageName         = "kind_docker_image"
$containerName     = "kind_container"
$network_type      = "--network=host"
$socket_volume     = "/var/run/docker.sock:/var/run/docker.sock"
$playbook_exec     = "ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml"
$argocd_install    = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
$apply_app         = "kubectl apply -f application.yaml"

$remove_app        = "rm application.yaml"
$kubectl_endpoints = "kubectl get endpoints"
$kyverno_config    = "kubectl apply -f charts/dev/kyverno/templates/clusterpolicy.yaml"

# Docker Variables
$KindDelCmd      = "docker exec -it $containerName sh -c 'kind delete cluster'"
$DockerStopCmd   = "docker stop $containerName"
$DockerRemoveCmd = "docker rm $containerName"
$DockerBuildCmd  = "docker build -t $imageName ."
$DockerRunCmd    = "docker run -d $network_type -v $socket_volume --name $containerName $imageName"

# Ansible Variables
$AnsiblePlaybook = "docker exec -it $containerName sh -c '$playbook_exec'"

# ArgoCD variables
$Install_ArgoCD = "docker exec -it $containerName sh -c '$argocd_install'"
$Apply_ArgoApp  = "docker exec -it $containerName sh -c '$apply_app'"
$Remove_ArgoApp = "docker exec -it $containerName sh -c '$remove_app'"

# Kubernetes Environment Variables
$K8s_Endpoints  = "docker exec -it $containerName sh -c '$kubectl_endpoints'"
$Bad_Interp_Fix = "docker exec -it $containerName sh -c 'dos2unix argocd/argocd.sh'"
$Argocd_Script  = "docker exec -it $containerName sh -c 'argocd/argocd.sh'"
$Apply_Kyverno  = "docker exec -it $containerName sh -c '$kyverno_config'"

## RUN commands ##

# Execute Docker container to delete kind cluster
Invoke-Expression -Command $KindDelCmd
# Stop the Docker container
Invoke-Expression -Command $DockerStopCmd
# Remove the Docker container
Invoke-Expression -Command $DockerRemoveCmd

# Rebuild
Invoke-Expression -Command $DockerBuildCmd
Invoke-Expression -Command $DockerRunCmd
Invoke-Expression -Command $AnsiblePlaybook

# Argocd install and manifest application ##
Invoke-Expression -Command $Install_ArgoCD
Write-Output "Waiting for argocd pods creation..."
Start-Sleep -Seconds 80

Write-Output "Cluster kubernetes is ready for argocd configuration!"
Invoke-Expression -Command $Bad_Interp_Fix
Invoke-Expression -Command $K8s_Endpoints

# Invoke-Expression -Command $Apply_Kyverno