$containerName = "kind_container"

# Docker exec bash
$KindExecCommand = "docker exec -it $containerName /bin/bash"

Write-Output "`nDocker container env, welcome aboard! =)`n"

# Execute Kind Cluster
Invoke-Expression -Command $KindExecCommand