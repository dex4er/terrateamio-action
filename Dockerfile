FROM ghcr.io/terrateamio/action-base:latest

COPY entrypoint.sh /entrypoint.sh
COPY terrat_runner /terrat_runner
COPY terrateam-pre-action /terrateam-pre-action

ENTRYPOINT ["/entrypoint.sh"]
