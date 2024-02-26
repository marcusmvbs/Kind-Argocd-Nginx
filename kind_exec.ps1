# Common Variables
$containerName = "kind_container"

# Versions
$kubectl_pods       = "kubectl get pods -A"
$k_kyverno_policies = "kubectl get clusterpolicies.kyverno.io"

# Docker exec bash
$KubectlGetPods  = "docker exec -it $containerName sh -c '$kubectl_pods'"
$KubectlKyverno  = "docker exec -it $containerName sh -c '$k_kyverno_policies'"
$KindExecCommand = "docker exec -it $containerName /bin/bash"

## Run Commands ##
Invoke-Expression -Command $KubectlGetPods

# Invoke-Expression -Command $KubectlKyverno

# Execute Kind Cluster
Invoke-Expression -Command $KindExecCommand