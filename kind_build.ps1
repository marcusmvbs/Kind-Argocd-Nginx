# Common Variables
$imageName         = "kind_docker_image"
$containerName     = "kind_container"
$network_type      = "--network=host"
$socket_volume     = "/var/run/docker.sock:/var/run/docker.sock"
$playbook_exec     = "ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml"
$argocd_install    = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
$kubectl_endpoints = "kubectl get endpoints"
$dos2unix          = "dos2unix argocd/argocd.sh"
$kyverno_config    = "kubectl apply -f charts/dev/kyverno/templates/clusterpolicy.yaml"

# Docker Variables
$DockerBuildCmd = "docker build -t $imageName ."
$DockerRunCmd   = "docker run -d $network_type -v $socket_volume --name $containerName $imageName"

# Ansible Variables
$AnsiblePlaybook = "docker exec -it $containerName sh -c '$playbook_exec'"

# ArgoCD variables
$Install_ArgoCD     = "docker exec -it $containerName sh -c '$argocd_install'"

# Kubernetes Environment Variables
$K8s_Endpoints  = "docker exec -it $containerName sh -c '$kubectl_endpoints'"
$Bad_Interp_Fix = "docker exec -it $containerName sh -c '$dos2unix'"
$Apply_Kyverno  = "docker exec -it $containerName sh -c '$kyverno_config'"

## RUN commands ##

# Build Docker container
Invoke-Expression -Command $DockerBuildCmd
# Run Docker container
Invoke-Expression -Command $DockerRunCmd

# Execute Ansible tasks
Invoke-Expression -Command $AnsiblePlaybook
Start-Sleep -Seconds 10

# Argocd config
Invoke-Expression -Command $Install_ArgoCD

Invoke-Expression -Command $K8s_Endpoints

Write-Output "Waiting for argocd pods creation..."
Start-Sleep -Seconds 80

Write-Output "Cluster kubernetes is ready for argocd configuration!"
Invoke-Expression -Command $Bad_Interp_Fix

# Invoke-Expression -Command $Apply_Kyverno