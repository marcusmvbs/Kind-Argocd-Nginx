# ArgoCD-Rollouts
Docker > Ansible > Kind > ... > Argocd

# Needed 
Prometheus -> kube prom, grafana -> loki & mimi
Ingress, Cert Manager & Lets encrypt
Trivy - Scan container image (Security)
Kyverno - Native Policy Management (Validate, Change or Create new resources)

kubectl apply -f kind-config/charts/dev/kyverno/deployment.yaml
kubectl get clusterpolicies.kyverno.io
kubectl run nginx --image nginx --dry-run=client -o yaml > /kind-config/charts/dev/nginx/templates/pod.yaml