# Common Variables
$imageName      = "kind_docker_image"
$containerName  = "kind_container"
$network_type   = "--network=host"
$socket_volume  = "/var/run/docker.sock:/var/run/docker.sock"
$playbook_exec  = "ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml"
$argocd_install = "kubectl apply -n argocd-ns -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
$apply_app      = "kubectl apply -f application.yaml"
$gitlab_token   = "gitlab_access.sh"
$argo_server_pf = "kubectl port-forward service/argocd-server -n argocd-ns 8080:443"
$kubectl_pods   = "kubectl get pods -n webserver-ns"
$remove_app     = "rm application.yaml"
$kyverno_config = "kubectl apply -f charts/dev/kyverno/templates/clusterpolicy.yaml"

# Docker Variables
$KindDelCmd      = "docker exec -it $containerName sh -c 'kind delete cluster'"
$DockerStopCmd   = "docker stop $containerName"
$DockerRemoveCmd = "docker rm $containerName"
$DockerBuildCmd  = "docker build -t $imageName ."
$DockerRunCmd    = "docker run -d $network_type -v $socket_volume --name $containerName $imageName"

# Ansible Variables
$AnsiblePlaybook = "docker exec -it $containerName sh -c '$playbook_exec'"

# ArgoCD variables
$Apply_ArgoCD     = "docker exec -it $containerName sh -c '$argocd_install'"
$Apply_ArgoApp    = "docker exec -it $containerName sh -c '$apply_app'"
$Remove_ArgoApp   = "docker exec -it $containerName sh -c '$remove_app'"
$Argocd_Gitlab    = "docker exec -it $containerName sh -c '$gitlab_token'"
$Kube_URL_enabled = "docker exec -it $containerName sh -c '$argo_server_pf'"

# Kubernetes Environment Variables
$KubectlGetPods   = "docker exec -it $containerName sh -c '$kubectl_pods'"
$Apply_Kyverno    = "docker exec -it $containerName sh -c '$kyverno_config'"

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
Start-Sleep -Seconds 5

# Argocd install and manifest application ##
Invoke-Expression -Command $Apply_ArgoCD
Invoke-Expression -Command $Apply_ArgoApp
Invoke-Expression -Command $Remove_ArgoApp

# Login to ArgoCD using the personal access token
Invoke-Expression -Command $Kube_URL_enabled
Invoke-Expression -Command $Argocd_Gitlab

Start-Sleep -Seconds 15
Invoke-Expression -Command $KubectlGetPods

# # Apply Kubernetes config
# Start-Sleep -Seconds 120
# Invoke-Expression -Command $Apply_Kyverno