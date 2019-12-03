FROM sixeyed/eksctl:0.10.2

# helm
RUN apk --no-cache update && \
    apk --no-cache add jq openssl && \ 
    curl -L https://git.io/get_helm.sh | sh

# compose-on-kubernetes installer
RUN curl -LO https://github.com/docker/compose-on-kubernetes/releases/download/v0.4.23/installer-linux && \
    chmod +x ./installer-linux && \
    mv ./installer-linux /usr/local/bin/

ENTRYPOINT ["/bin/sh"]
CMD ["/setup.sh"]

COPY compose-etcd.yaml /
COPY setup.sh /