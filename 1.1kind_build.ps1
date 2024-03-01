# Common Variables
$imageName           = "kind_docker_image"
$containerName       = "kind_container"
$network_type        = "--network=host"
$socket_volume       = "/var/run/docker.sock:/var/run/docker.sock"
$playbook_exec       = "ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml"
$argocd_install      = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
$kubectl_pods        = "kubectl get pods -n argocd"
$kubectl_endpoints   = "kubectl get endpoints"
$dos2unix_argocd     = "dos2unix kind/argocd_config.sh"
$dos2unix_nginx_sync = "dos2unix kind/argo_nginx_sync.sh"

# Docker Variables
$DockerBuildCmd = "docker build -t $imageName ."
$DockerRunCmd   = "docker run -d $network_type -v $socket_volume --name $containerName $imageName"

# Ansible Variables
$AnsiblePlaybook = "docker exec -it $containerName sh -c '$playbook_exec'"

# ArgoCD variables
$Install_ArgoCD = "docker exec -it $containerName sh -c '$argocd_install'"
$Argo_Pods      = "docker exec -it $containerName sh -c '$kubectl_pods'"

# Kubernetes Environment Variables
$K8s_Endpoints   = "docker exec -it $containerName sh -c '$kubectl_endpoints'"
$Bad_Interp_Fix1 = "docker exec -it $containerName sh -c '$dos2unix_argocd'"
$Bad_Interp_Fix2 = "docker exec -it $containerName sh -c '$dos2unix_nginx_sync'"

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
Write-Output "Waiting for argocd pods creation..."
Start-Sleep -Seconds 80
Invoke-Expression -Command $Argo_Pods
Invoke-Expression -Command $Bad_Interp_Fix1
Invoke-Expression -Command $Bad_Interp_Fix2
Invoke-Expression -Command $K8s_Endpoints

Write-Output "`nArgoCD is ready on kubernetes cluster. Execute the following command to continue argocd configuration:`n"
Write-Output "      $ powershell.exe -File .\2.0argocd_config.ps1'`n"