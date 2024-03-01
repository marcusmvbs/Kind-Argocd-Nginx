###

$Argocd_Script   = "docker exec -it $containerName sh -c './argocd/argocd.sh'"

Invoke-Expression -Command $Argocd_Script