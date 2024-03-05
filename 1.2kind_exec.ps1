# Common Variables
$containerName = "kind_container"
$kubectl_pods  = "kubectl get pods -n webserver"

# Docker exec bash
$KubectlGetPods  = "docker exec -it $containerName sh -c '$kubectl_pods'"
$KindExecCommand = "docker exec -it $containerName /bin/bash"

## Run Commands ##
Invoke-Expression -Command $KubectlGetPods
Write-Output "`nDocker container env, welcome aboard! =) `n`n"


Write-Output "Nginx service available:$ kubectl port-forward svc/nginx-svc 32000:80 -n webserver `n"

# Execute Kind Cluster
Invoke-Expression -Command $KindExecCommand

# $Rollout = "docker exec -it $containerName sh -c 'kubectl argo rollouts get rollout nginx-deploy -n webserver --watch'"
# Invoke-Expression -Command $Rollout