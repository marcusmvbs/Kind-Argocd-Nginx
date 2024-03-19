# Common Variables
$containerName = "kind_container"
$kubectl_pods  = "watch kubectl get pods -n monitoring"

# Docker exec bash
$KubectlGetPods = "docker exec -it $containerName sh -c '$kubectl_pods'"

Invoke-Expression -Command $KubectlGetPods