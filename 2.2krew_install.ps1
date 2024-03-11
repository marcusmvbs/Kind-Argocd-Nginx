$containerName = "kind_container"

$Krew_Install = "docker exec -it $containerName sh -c 'kind/krew_install.sh'"
$Export_Krew_Path = "docker exec -it $containerName sh -c 'export PATH='${KREW_ROOT:-$HOME/.krew}/bin:$PATH''"

Invoke-Expression -Command $Krew_Install
Invoke-Expression -Command $Export_Krew_Path