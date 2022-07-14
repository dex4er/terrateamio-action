FROM ghcr.io/terrateamio/action-base:latest

RUN curl -fsSL -o /tmp/configure-aws-credentials.tar.gz "https://github.com/terrateamio/packages/raw/main/aws/configure-aws-credentials-v1.6.1.tar.gz" \
        && tar -C /tmp -xzf /tmp/configure-aws-credentials.tar.gz \
        && curl -fsSL -o /tmp/node-linux-x64.tar.gz "https://github.com/terrateamio/packages/raw/main/node/node-v16.16.0-linux-x64.tar.gz" \
        && tar -C /tmp -xzf /tmp/node-linux-x64.tar.gz \
        && mv /tmp/node-v16.16.0-linux-x64/bin/node /usr/local/bin/node \
        && cd /tmp/configure-aws-credentials-1.6.1 \
        && /tmp/node-v16.16.0-linux-x64/bin/npm i \
        && /tmp/node-v16.16.0-linux-x64/bin/npm run package \
        && mv dist/index.js /usr/local/bin/configure-aws-credentials \
        && rm -rf /tmp/configure-aws-credentials* /tmp/node* /tmp/ncc-cache

COPY entrypoint.sh /entrypoint.sh
COPY terrat_runner /terrat_runner

ENTRYPOINT ["/entrypoint.sh"]
