#!/bin/bash

GIT_CONFIG_KEY="yevhenhrytsai.pre-commit-gitleaks"

if [[ $(git config "$GIT_CONFIG_KEY") != "true" ]]; then
    echo "[INFO] Skipping pre-commit gitleaks check. Hook is disabled"
    exit 0
fi

gitleaks detect --source . -v --no-git
