FROM sixeyed/aws-cli:1.16.294

ARG EKSCTL_VERSION=0.10.2
ARG KUBECTL_VERSION=1.16.3

#eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/$EKSCTL_VERSION/eksctl_Linux_amd64.tar.gz" | \
    tar xz -C /usr/local/bin

# kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/

WORKDIR /data
ENTRYPOINT ["sh"]