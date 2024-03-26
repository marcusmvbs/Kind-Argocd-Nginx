# Common Variables
$imageName     = "21121953/pyflask_app"
$containerName = "kind_container"
$app_deploy    = "kubectl apply -f /kind/kubernetes/pyflask_app/templates/deployment.yaml"
$app_svc       = "kubectl apply -f /kind/kubernetes/pyflask_app/templates/service.yaml"
# $A             = "$(sed "s/{{COLOR}}/blue/g" ./kind/kubernetes/python_app/templates/index.html.template > ./kind/kubernetes/python_app/templates/index.html)"

# Docker Variables
$DockerBuild    = "docker build -t $imageName .\kind\kubernetes\pyflask_app\"
$DockerLogin    = "docker login"
$DockerPush     = "docker push $imageName"
$PyFlask_Deploy = "docker exec -it $containerName sh -c '$app_deploy'"
$PyFlask_Svc    = "docker exec -it $containerName sh -c '$app_svc'"

## RUN commands ##
Invoke-Expression -Command $DockerBuild
Start-Sleep -Seconds 2
Invoke-Expression -Command $DockerLogin
Start-Sleep -Seconds 2
Invoke-Expression -Command $DockerPush
Start-Sleep -Seconds 2
Invoke-Expression -Command $PyFlask_Deploy
Start-Sleep -Seconds 2
Invoke-Expression -Command $PyFlask_Svc