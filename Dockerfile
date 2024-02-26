FROM ubuntu:22.04

LABEL maintainer="Marcus Vinicius Barros da Silva <marcus.mvbs@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \ 
    apt-get install -y --no-install-recommends \
    gnupg curl wget ca-certificates apt-utils apt-transport-https \
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
RUN mkdir -p /Ansible /Kind
COPY Ansible/ /Ansible/
COPY Kind/ /Kind/
COPY application.yaml application.yaml

COPY hard_deploy.yaml ./hard_deploy_nginx.yaml

# WORKDIR /kind-config/

# Set up an entrypoint script to initialize Kind cluster
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose any necessary ports
EXPOSE 6443

# Set the entrypoint script
ENTRYPOINT ["entrypoint.sh"]