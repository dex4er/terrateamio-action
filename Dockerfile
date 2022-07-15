FROM ghcr.io/terrateamio/action-base:latest

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  nodejs \
  npm

COPY configure-aws-credentials /configure-aws-credentials
RUN cd /configure-aws-credentials \
  && npm i \
  && npm run package \
  && mv dist/index.js /usr/local/bin/configure-aws-credentials \
  && rm -rf /configure-aws-credentials

COPY google-auth /google-auth
RUN cd /google-auth \
  && npm i \
  && npm run build \
  && mv dist/main/index.js /usr/local/bin/google-auth \
  && rm -rf /google-auth

COPY azure-login /azure-login
RUN cd /azure-login \
  && npm i \
  && chmod +x ./node_modules/.bin/tsc \
  && npm run build \
  && npm i -g @vercel/ncc \
  && ncc build src/main.ts \
  && mv dist /usr/local/bin/azure-login \
  && rm -rf /azure-login

COPY entrypoint.sh /entrypoint.sh
COPY terrat_runner /terrat_runner
COPY terrateam-pre-action /terrateam-pre-action

ENTRYPOINT ["/entrypoint.sh"]
