# Common Variables
$imageName         = "kind_docker_image"
$containerName     = "kind_container"
$network_type      = "--network=host"
$socket_volume     = "/var/run/docker.sock:/var/run/docker.sock"
$playbook_exec     = "ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml"
$argocd_install    = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
$kubectl_endpoints = "kubectl get endpoints"
$dos2unix_argocd   = "dos2unix kind/kubernetes/argocd/argocd_config.sh"

$apply_roles       = "kubectl apply -f /kind/kubernetes/clusterroles.yaml"
$apply_rolebinding = "kubectl apply -f /kind/kubernetes/rolebindings.yaml"

# Docker Variables
$DockerBuildCmd = "docker build -t $imageName ."
$DockerRunCmd   = "docker run -d $network_type -v $socket_volume --name $containerName $imageName"

$AnsiblePlaybook = "docker exec -it $containerName sh -c '$playbook_exec'"

$Install_ArgoCD = "docker exec -it $containerName sh -c '$argocd_install'"

$K8s_Endpoints  = "docker exec -it $containerName sh -c '$kubectl_endpoints'"
$Bad_Interp_Fix = "docker exec -it $containerName sh -c '$dos2unix_argocd'"

# Kubernetes Service Account, ClusterRole, ClusterRoleBinding
$Apply_cRole  = "docker exec -it $containerName sh -c '$apply_roles'"
$Apply_crb    = "docker exec -it $containerName sh -c '$apply_rolebinding'"


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
# Write-Output "Waiting for argocd pods creation..."
# Start-Sleep -Seconds 35


Invoke-Expression -Command $Bad_Interp_Fix
Invoke-Expression -Command $K8s_Endpoints
Write-Output ""

# kubernetes cRoles and cRolebindings 
Invoke-Expression -Command $Apply_cRole
Start-Sleep -Seconds 2
Invoke-Expression -Command $Apply_crb


Write-Output "`nArgoCD is ready on kubernetes cluster. Execute the following command to continue configuration:`n"
Write-Output "     $ powershell.exe -File .\2.0pod_watch.ps1"
Write-Output "     $ powershell.exe -File .\2.1argocd_sync.ps1"
Write-Output "     $ powershell.exe -File .\2.2krew_install.ps1"
Write-Output "     $ powershell.exe -File .\2.3kubernetes_dashboard.ps1"
Write-Output "     $ powershell.exe -File .\2.4prometheus_config.ps1"
Write-Output "`nNginx server is running on http://localhost:30000`n"