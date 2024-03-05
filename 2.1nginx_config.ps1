# Nginx webpage configuration
$containerName = "kind_container"

$Nginx_webpage = "docker exec -it $containerName sh -c 'kind/nginx_config.sh'"

Invoke-Expression -Command $Nginx_webpage