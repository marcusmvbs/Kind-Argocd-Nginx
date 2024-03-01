# Common Variable
$containerName = "kind_container"

# Docker Variables
$KindDelCmd        = "docker exec -it $containerName sh -c 'kind delete cluster'"
$DockerStopCmd     = "docker stop $containerName"
$DockerRemoveCmd   = "docker rm $containerName"
$DockerImagePrune  = "docker image prune --all --force"
$DockerSystemPrune = "docker system prune -f"

# Execute Docker container to delete kind cluster
Invoke-Expression -Command $KindDelCmd
# Stop the Docker container
Invoke-Expression -Command $DockerStopCmd
# Remove the Docker container
Invoke-Expression -Command $DockerRemoveCmd
# Remove Docker images
Invoke-Expression -Command $DockerImagePrune
# Remove Docker volumes
Invoke-Expression -Command $DockerSystemPrune