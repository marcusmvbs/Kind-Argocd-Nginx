# Common Variables
$imageName     = "21121953/py_spark"
$containerName = "kind_container"
$app_deploy    = "kubectl apply -f /kind/kubernetes/py_spark/templates/deployment.yaml"
$app_svc       = "kubectl apply -f /kind/kubernetes/py_spark/templates/service.yaml"

# Docker Variables
$DockerBuild     = "docker build -t $imageName .\kind\kubernetes\py_spark\"
$DockerLogin     = "docker login"
$DockerPush      = "docker push $imageName"
$SparkEnv_Deploy = "docker exec -it $containerName sh -c '$app_deploy'"
$SparkEnv_Svc    = "docker exec -it $containerName sh -c '$app_svc'"

## RUN commands ##
Invoke-Expression -Command $DockerBuild
Start-Sleep -Seconds 2
Invoke-Expression -Command $DockerLogin
Start-Sleep -Seconds 2
Invoke-Expression -Command $DockerPush
Start-Sleep -Seconds 2
# Invoke-Expression -Command $SparkEnv_Deploy
Start-Sleep -Seconds 2
# Invoke-Expression -Command $SparkEnv_Svc