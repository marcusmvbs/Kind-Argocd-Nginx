FROM ubuntu:22.04

LABEL maintainer="Marcus Vinicius Barros da Silva <marcus.mvbs@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \ 
    apt-get install -y --no-install-recommends \
    gnupg curl wget ca-certificates \
    apt-utils apt-transport-https dos2unix vim \
    net-tools \
    python3 python3-pip python3-apt \
    ansible \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip && \
    ansible-galaxy collection install community.general community.kubernetes

# Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

# Storing Ansible, Kind, ArgoCD application
RUN mkdir -p /ansible /kind /charts /web-files
RUN chmod -R 755 /web-files
COPY ansible/ /ansible/
COPY kind/ /kind/
COPY charts/ /charts/
COPY web-files/html/index.html /web-files/index.html
RUN chmod 644 /web-files/index.html

# Argocd and Nginx Config
COPY application.yaml application.yaml
RUN chmod +x /kind/argocd_config.sh
RUN chmod +x /kind/nginx_config.sh

# Expose any necessary ports
EXPOSE 6443 8080 8443 32000

ENTRYPOINT ["sh", "-c", "tail -f /dev/null"]