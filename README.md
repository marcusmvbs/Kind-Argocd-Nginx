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

kubectl port-forward svc/argocd-server -n argocd 6443:443 --address 0.0.0.0 &

argocd admin initial-password -n argocd
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
argocd login 0.0.0.0:644
username: admin
password: 9E5iSNhTC1TRbG4A -> decrypt using base64
---
argocd cluster add kind-kind
kubectl config set-context --current --namespace=argocd
argocd cluster list
---
argocd app create nginx-app --repo https://github.com/marcusmvbs/argocd-features.git --path . --dest-server cluster_name_added dest-namespace webserver
argocd app get nginx-app
argocd app sync nginx-app
argocd app delete nginx-app

# Nginx steps

kubectl port-forward svc/nginx-svc -n webserver-ns 80:80