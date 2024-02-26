# Common Variables
$containerName = "kind_container"

# Versions
$kubectl_pods = "kubectl get pods -A"

# Docker exec bash
$KubectlGetPods  = "docker exec -it $containerName sh -c '$kubectl_pods'"
$KindExecCommand = "docker exec -it $containerName /bin/bash"

## Run Commands ##
Invoke-Expression -Command $KubectlGetPods

# Execute Kind Cluster
Invoke-Expression -Command $KindExecCommand