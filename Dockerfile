FROM ubuntu:22.04

LABEL maintainer="Marcus Vinicius Barros da Silva <marcus.mvbs@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \ 
    apt-get install -y --no-install-recommends \
    gnupg curl wget ca-certificates \
    apt-utils apt-transport-https dos2unix vim \
    net-tools jq \
    python3 python3-pip python3-apt \
    ansible \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip && \
    ansible-galaxy collection install community.general community.kubernetes

# GCP Auth
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-469.0.0-linux-x86_64.tar.gz && \
    tar -xzf google-cloud-cli-469.0.0-linux-x86_64.tar.gz -C /usr/local/ && \
    ln -s /usr/local/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud && \
    sh /usr/local/google-cloud-sdk/install.sh

# Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

# Storing Ansible, Kind, ArgoCD application
RUN mkdir -p /ansible /kind /charts
COPY ansible/ /ansible/
COPY kind/ /kind/
COPY charts/ /charts/

# Argocd and Nginx Config
COPY application.yaml application.yaml
RUN chmod +x /kind/kubernetes/argocd/argocd_config.sh
RUN chmod +x /kind/kubernetes/go_app/script/app_config.sh
RUN chmod +x /kind/krew_install.sh
RUN chmod 644 /kind/kubernetes/nginx/html/index.html

# Expose any necessary ports
EXPOSE 6443 8443 9090 8081 9115

ENTRYPOINT ["sh", "-c", "tail -f /dev/null"]