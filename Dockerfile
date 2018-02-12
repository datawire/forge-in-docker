FROM alpine:3.7
MAINTAINER Datawire <dev@datawire.io>
LABEL PROJECT_REPO_URL         = "git@github.com:datawire/forge-in-docker.git" \
      PROJECT_REPO_BROWSER_URL = "https://github.com/datawire/forge-in-docker" \
      DESCRIPTION              = "Forge in Docker" \
      VENDOR                   = "Datawire, Inc." \
      VENDOR_URL               = "https://datawire.io/"

ENV GOSU_VERSION=1.10
ENV KUBECTL_VERSION=v1.9.3
ENV FORGE_VERSION=0.4.1

RUN apk --no-cache add ca-certificates docker python2 python2-dev \
    && apk --no-cache add --virtual build-dependencies curl \
    && curl -O --location --silent --show-error https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 \
    && mv gosu-amd64 /usr/local/bin/gosu \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
    && mv kubectl /usr/local/bin/kubectl \
    && curl -L --output forge "https://s3.amazonaws.com/datawire-static-files/forge/$FORGE_VERSION/forge?x-download=datawire" \
    && mv forge /usr/local/bin/forge \  
    && chmod +x /usr/local/bin/kubectl /usr/local/bin/forge /usr/local/bin/gosu \
    && apk del --purge build-dependencies \
    && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python2.7 /usr/bin/python; fi \
    && rm -rf /root/.cache

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
