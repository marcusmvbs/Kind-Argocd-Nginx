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

kubectl apply -f kind-config/charts/dev/kyverno/templates/deployment.yaml
kubectl get clusterpolicies.kyverno.io

##Next command creates a default nginx pod with no cache and add a yaml file as a template## 
kubectl run nginx --image nginx --dry-run=client -o yaml > /kind-config/charts/dev/nginx/templates/pod.yaml