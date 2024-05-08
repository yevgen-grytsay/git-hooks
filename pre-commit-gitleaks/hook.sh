#!/bin/bash

if [[ $(git config "$GIT_CONFIG_KEY") != "true" ]]; then
    echo "[INFO] Hook is disabled"
    exit 0
fi

gitleaks detect --source . -v --no-git
