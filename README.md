# ArgoCD-Rollouts
Docker ✓ > Ansible ✓ > Kind ✓ > Helm Tools (kyverno ✓/nginx ✓/cert-manager X/argo-workflows X/nginx-ingress X) > 
Argocd ✓ > Gitops-Github ✓


# Difficulties
- Argocd UI connection not completed.

# Needed 
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

