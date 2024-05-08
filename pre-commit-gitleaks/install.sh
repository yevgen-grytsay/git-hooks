#!/bin/bash

set -e

ENABLE_HOOK="$1"

HOOK_FILE_NAME="hook.sh"
HOOK_FILE_URL="https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/v1.0.1/pre-commit-gitleaks/$HOOK_FILE_NAME"
GIT_CONFIG_KEY="yevhenhrytsai.pre-commit-gitleaks"


gitleaks_release_version="8.18.2"


# script_dir=$(dirname $0)
script_dir=$(pwd)

install_gitleaks_once() {
    if [[ $(which gitleaks) ]]; then
        echo "[INFO] found gitleak installation"
    else
        echo "[INFO] installing gitleak..."
        install_gitleaks
    fi
}

install_gitleaks() {
    local osname=$(uname)
    local os=""
    local ext=""
    local arch=""

    if [[ $osname == "Linux" ]]; then
        os="linux"
        ext=".tar.gz"
        # echo "[OK] OS detected: Linux"
    elif [[ $osname =~ (CYGWIN.*)|(MINGW.*) ]]; then
        os="windows"
        ext=".zip"
        # echo "[OK] OS detected: Windows"
    else
        echo "[ERROR] Unsupported OS"
        exit 1
    fi

    case $(uname -m) in
        i386)   arch="x32" ;;
        i686)   arch="x32" ;;
        x86_64) arch="x64" ;;
        *)
            echo "[ERROR] Unsupported architecture"
            exit 1 ;;
        # arm)    dpkg --print-architecture | grep -q "arm64" && arch="arm64" || arch="arm" ;;
    esac

    echo "[INFO] Platform detected (arch=$arch, os=$os)"

    local gitleaks_release_file="gitleaks_${gitleaks_release_version}_${os}_${arch}${ext}"
    local gitleaks_release_url="https://github.com/gitleaks/gitleaks/releases/download/v${gitleaks_release_version}/${gitleaks_release_file}"
    local local_archive="$HOME/${gitleaks_release_file}"

    echo "[INFO] Downloading file ${gitleaks_release_url}"
    curl -o "${local_archive}" -Ls --fail --show-error ${gitleaks_release_url}

    if [[ $os == "windows" ]]; then
        local unarch_dir="${LOCALAPPDATA}/gitleaks_${gitleaks_release_version}_${os}_${arch}"
        local bin_dir="$HOME/bin"

        unzip -o "$HOME/${gitleaks_release_file}" -d $unarch_dir
        mkdir -p "$bin_dir"
        mv "${unarch_dir}/gitleaks.exe" "$bin_dir/gitleaks.exe"
        rm -rf "$unarch_dir"
        rm "$local_archive"
    elif [[ $os == "linux" ]]; then
        local unarch_dir="$HOME/gitleaks_${gitleaks_release_version}_${os}_${arch}"
        local bin_dir="/usr/local/bin"

        mkdir $unarch_dir
        tar -xf "$local_archive" -C $unarch_dir
        runAsRoot mv "${unarch_dir}/gitleaks" "$bin_dir/gitleaks"
        rm -rf "${unarch_dir}"
    else
        echo "[ERROR] No installation method for os: ${os}"
        exit 1
    fi
}

install_hook_once() {
    if [[ -n $(git config "$GIT_CONFIG_KEY") ]]; then
        echo "[INFO] Skip installation: already installed."
        echo "[INFO]   run 'git config --unset $GIT_CONFIG_KEY; ./pre-commit-gitleaks/install.sh enable' to force installation"
    else
        install_hook
    fi
}

install_hook() {
    if [[ -z $(git rev-parse --git-dir) ]]; then
        echo "[ERROR] Not inside git repository"
        exit 1
    fi

    local hooks_dir="$script_dir/.git/hooks"
    local hook_file="$hooks_dir/pre-commit"
    if [[ -d $hook_file ]]; then
        echo "[ERROR] Can not install script: directory with conflicting name already exists: $hook_file"
        exit 1
    fi

    curl -o "$HOOK_FILE_NAME" -Ls --fail --show-error "$HOOK_FILE_URL"
    mv -i "$HOOK_FILE_NAME" "$hook_file"
    chmod +x "$hook_file"
}

# https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh
runAsRoot() {
    local CMD="$*"

    if [ $EUID -ne 0 ]; then
        CMD="sudo $CMD"
    fi

    $CMD
}


install_gitleaks_once

install_hook_once


if [[ -n "$ENABLE_HOOK" ]]; then
    case "$ENABLE_HOOK" in
        enable)
            git config "$GIT_CONFIG_KEY" true
            echo "[INFO] Hook enabled" ;;
        disable)
            # git config --unset "$GIT_CONFIG_KEY"
            git config "$GIT_CONFIG_KEY" false
            echo "[INFO] Hook disabled" ;;
    esac
fi
