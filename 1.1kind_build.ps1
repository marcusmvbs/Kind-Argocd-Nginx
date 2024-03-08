# Common Variables
$imageName           = "kind_docker_image"
$containerName       = "kind_container"
$network_type        = "--network=host"
$socket_volume       = "/var/run/docker.sock:/var/run/docker.sock"
$playbook_exec       = "ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml"
$argocd_install      = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
$kubectl_pods        = "kubectl get pods -A"
$kubectl_svc         = "kubectl get svc -A"
$kubectl_endpoints   = "kubectl get endpoints"
$dos2unix_argocd     = "dos2unix kind/argocd_config.sh"

# Docker Variables
$DockerBuildCmd = "docker build -t $imageName ."
$DockerRunCmd   = "docker run -d $network_type -v $socket_volume --name $containerName $imageName"

# Ansible Variables
$AnsiblePlaybook = "docker exec -it $containerName sh -c '$playbook_exec'"

# ArgoCD variables
$Install_ArgoCD = "docker exec -it $containerName sh -c '$argocd_install'"
$Get_Pods       = "docker exec -it $containerName sh -c '$kubectl_pods'"
$Get_Svc        = "docker exec -it $containerName sh -c '$kubectl_svc'"
# Kubernetes Environment Variables
$K8s_Endpoints  = "docker exec -it $containerName sh -c '$kubectl_endpoints'"
$Bad_Interp_Fix = "docker exec -it $containerName sh -c '$dos2unix_argocd'"


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
# Start-Sleep -Seconds 80
Invoke-Expression -Command $Get_Pods
Invoke-Expression -Command $Get_Svc
Invoke-Expression -Command $Bad_Interp_Fix
Invoke-Expression -Command $K8s_Endpoints

# Write-Output "`nNginx server is running on http://localhost:32000"
# Write-Output "`nArgoCD is ready on kubernetes cluster. Execute the following command to continue configuration:`n"
# Write-Output "      $ powershell.exe -File .\2.0argocd_config.ps1'"
# Write-Output "      $ powershell.exe -File .\2.1nginx_config.ps1'`n"