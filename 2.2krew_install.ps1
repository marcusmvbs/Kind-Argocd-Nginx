$containerName = "kind_container"

$Krew_Install = "docker exec -it $containerName sh -c 'kind/krew_install.sh'"

Invoke-Expression -Command $Krew_Install