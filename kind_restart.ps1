# Dot Sourcing
. ".\kind_build.ps1"
. ".\kind_remove.ps1"

## RUN commands ##
# Clean up
Invoke-Expression -Command $KindDelCmd
Invoke-Expression -Command $DockerStopCmd
Invoke-Expression -Command $DockerRemoveCmd

## Rebuild ##
Invoke-Expression -Command $DockerBuildCmd
Invoke-Expression -Command $DockerRunCmd
Invoke-Expression -Command $AnsiblePlaybook

## Argocd install ##
Invoke-Expression -Command $Install_ArgoCD
Write-Output "Waiting for argocd pods creation..."
Start-Sleep -Seconds 80

Write-Output "Cluster kubernetes is ready for argocd configuration!"
Invoke-Expression -Command $Bad_Interp_Fix
Invoke-Expression -Command $K8s_Endpoints

## Execution continues in the file below ##
& ".\argocd_config.ps1"