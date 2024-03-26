    #gcloud init --console-only --project nginx-ingress-external-ip
    # link browser, copy and paste on terminal
    # numeric choice of project

    # gcloud components update
    # gcloud auth login --no-launch-browser
    # gcloud config set project nginx-ingress-external-ip
    # gcloud compute addresses create ip-kind-server --region=us-central1
    #gcloud compute addresses list
    # 

kubectl edit svc nginx-ingress-nginx-ingress-controller -n nginx-ingress
add= loadBalancerIP: 34.41.215.157 / nodePort: 80:30080 / nodePort: 443:32000

