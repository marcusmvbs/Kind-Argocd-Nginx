# Common Variables
$containerName = "kind_container"

# Docker exec bash
$KindExecCommand = "docker exec -it $containerName /bin/bash"

## Run Commands ##
Write-Output "`nDocker container env, welcome aboard! =)`n"

# Execute Kind Cluster
Invoke-Expression -Command $KindExecCommand

# $Rollout = "docker exec -it $containerName sh -c 'kubectl argo rollouts get rollout nginx-deploy -n webserver --watch'"
# Invoke-Expression -Command $Rollout