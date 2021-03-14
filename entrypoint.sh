#!/bin/bash

set -e
echo "la"
cd "$GITHUB_WORKSPACE"
echo "la2"

if [ -n "${INPUT_NAME}" ];
then
  export CHECK_NAME=$INPUT_NAME;
else
  export CHECK_NAME="revive-action"
fi

LINT_PATH="./..."

if [ -n "${INPUT_PATH}" ]; then LINT_PATH=$INPUT_PATH; fi

IFS=';' read -ra ADDR <<< "$INPUT_EXCLUDE"
for i in "${ADDR[@]}"; do
  EXCLUDES="$EXCLUDES -exclude="$i""
done

if [ ! -z "${INPUT_CONFIG}" ]; then CONFIG="-config=$INPUT_CONFIG"; fi

if [ ! -z "${GITHUB_TOKEN}" ];
then
  sh -c "revive $CONFIG $EXCLUDES -formatter ndjson $LINT_PATH | revive-action"
else
  echo "Annotations inactive. No GitHub token provided"
  sh -c "revive $CONFIG $EXCLUDES -formatter friendly $LINT_PATH"
fi
