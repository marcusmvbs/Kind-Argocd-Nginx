# Ingress automation steps

#gcloud init --console-only --project nginx-ingress-external-ip
#gcloud components update
#gcloud compute addresses create ip-kind-server --region=us-central1
#gcloud compute addresses list

kubectl edit svc nginx-ingress-nginx-ingress-controller -n nginx-ingress
add= loadBalancerIP: 34.41.215.157 / nodePort: 80:30080 / nodePort: 443:32000
---
gcloud init --console-only --project nginx-ingress-external-ip
gcloud compute addresses create ip-kind-server --region=us-central1
gcloud compute addresses list
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml
