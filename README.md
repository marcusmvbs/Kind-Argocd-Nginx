# ArgoCD-Rollouts
Docker ✓ > Ansible ✓ > Kind ✓ > Helm Tools (kyverno ✓/nginx ✓/cert-manager X/argo-workflows X/nginx-ingress X) > 
Argocd ✓ > Gitops-Github ✓

# Difficulties
- Argocd UI connection not completed.

# Needed 
Trivy -> Scan container image (Security)

# Common cmds
kubectl logs <argocd-server-name> -n argocd-ns
kubectl apply --dry-run=client -f application.yaml ## To validate ##
argocd app get <application-name> -n <namespace>

kubectl get clusterpolicies.kyverno.io

##Next command creates a default nginx pod with no cache and add a yaml file as a template## 
kubectl run nginx --image nginx --dry-run=client -o yaml > /charts/dev/nginx/templates/pod.yaml

# Project execution steps

1. Ensure you have a Windows machine to run PowerShell commands.
2. Install Docker Desktop with standard configurations to deploy a Kind cluster.
3. Set up VSCode as your IDE to build the code. Install necessary extensions such as Ansible, Docker, Kubernetes, Python, and YAML to streamline the workflow.
4. Clone the repository to your local machine.
5. Open PowerShell in the root directory of the cloned repository.
6. Run the necessary PowerShell scripts to execute the project.