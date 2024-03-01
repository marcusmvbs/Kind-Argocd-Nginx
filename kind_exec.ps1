# Common Variables
$containerName      = "kind_container"
$kubectl_pods       = "kubectl get pods -n argocd"

# Docker exec bash
$KubectlGetPods  = "docker exec -it $containerName sh -c '$kubectl_pods'"
$KindExecCommand = "docker exec -it $containerName /bin/bash"

## Run Commands ##
Invoke-Expression -Command $KubectlGetPods
# Invoke-Expression -Command $KubectlKyverno
Write-Output "`nDocker container env, welcome aboard! =)`n"

# Execute Kind Cluster
Invoke-Expression -Command $KindExecCommand