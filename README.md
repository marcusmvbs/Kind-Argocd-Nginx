# ArgoCD-Rollouts
Docker > Ansible > Kind > ... > Argocd

# Needed 
✓ Kyverno    -> Native Policy Management (Validate, Change or Create new resources)
Ingress      ->
Prometheus   -> kube prom
Grafana      -> loki & mimi
Cert Manager -> Lets encrypt
Trivy        -> Scan container image (Security)
Fluentbit
Strimzi

kubectl apply -f hard_deploy_nginx.yaml
kubectl logs <argocd-server-name> -n argocd-ns
kubectl apply --dry-run=client -f application.yaml ## To validate ##
argocd app get <application-name> -n <namespace>


kubectl get clusterpolicies.kyverno.io

##Next command creates a default nginx pod with no cache and add a yaml file as a template## 
kubectl run nginx --image nginx --dry-run=client -o yaml > /charts/dev/nginx/templates/pod.yaml

# ArgoCD steps - https://argo-cd.readthedocs.io/en/stable/getting_started/

<!-- 
argocd admin initial-password -n argocd
#kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
kubectl port-forward svc/argocd-server -n argocd 6443:443 # --username=admin --password=A_SENHA_POR_FAVOR
argocd login 172.22.0.4:6443
username: admin
password: 9E5iSNhTC1TRbG4A -> decrypt using base64 
#argocd login 127.0.0.1:8080 --username admin --password "$ARGOCD_INITIAL_PASSWORD"
#kubectl config view
--> 
<k8s_endpoint> <admin_pswd>

kubectl get endpoints
vim ~/.kube/config
kubectl config set-context --current --namespace=argocd
argocd admin initial-password -n argocd
kubectl port-forward --address 0.0.0.0 service/argocd-server -n argocd 6443:443 &
*argocd login 172.22.0.4:6443 --username admin --password 387BmrOBFz47fnyF --core
*argocd cluster add kind-kind --server=172.22.0.4:6443 --insecure
argocd cluster list
---
#helm search repo bitnami
<!-- argocd app create nginx-ingress --repo https://charts.helm.sh/stable --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace nginx-ingress --dest-server 172.22.0.4:6443 -->
argocd app create aspnet-core --repo https://charts.helm.sh/stable --helm-chart nginx --revision 1.25.4 --dest-namespace webserver --dest-server 172.22.0.4:6443
## CURRENT TASK ##
argocd app get aspnet-core
argocd app sync aspnet-core
argocd app delete aspnet-core

# Aspnet steps

kubectl port-forward nginx-deploy-7d57d8f-j2ggw -n webserver 8443:443 &