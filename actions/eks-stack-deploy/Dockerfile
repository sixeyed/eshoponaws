FROM sixeyed/eksctl:0.10.2

# Docker - 19.x
RUN apk --no-cache update && \
    apk --no-cache add docker --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/sh"]
CMD ["/setup.sh"]

COPY setup.sh /