#!/usr/bin/env bash

if [ "$TERRATEAM_PRE_ACTION" == "TRUE" ]; then
  exec /usr/local/bin/terrateam-pre-action.sh
fi

WORK_TOKEN="$1"
API_BASE_URL="$2"

echo "Starting Terrat Runner"
exec python3 /terrat_runner/main.py \
        --work-token "$WORK_TOKEN" \
        --workspace "$GITHUB_WORKSPACE" \
        --api-base-url "$API_BASE_URL" \
        --run-id "$GITHUB_RUN_ID" \
        --sha "$GITHUB_SHA"
