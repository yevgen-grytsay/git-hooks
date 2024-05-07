#!/bin/sh

set -e

install() {

    UNAME=$(uname)

    if [[ $UNAME == "Linux" ]]; then
        os="linux"
        echo "[OK] OS detected: Linux"
    elif [[ $UNAME =~ (CYGWIN.*)|(MINGW.*) ]]; then
        os="windows"
        echo "[OK] OS detected: Windows"
    else
        echo "[ERROR] Unsupported OS"
        exit 1
    fi

    arch=""
    case $(uname -m) in
        i386)   arch="x32" ;;
        i686)   arch="x32" ;;
        x86_64) arch="x64" ;;
        *)
            echo "[ERROR] Unsupported architecture"
            exit 1
        # arm)    dpkg --print-architecture | grep -q "arm64" && arch="arm64" || arch="arm" ;;
    esac

    release_version="8.18.2"
    release_file="gitleaks_${release_version}_${os}_${arch}.zip"
    release_url="https://github.com/gitleaks/gitleaks/releases/download/v${release_version}/${release_file}"
    local_archive="$HOME/${release_file}"
    
    echo "[INFO] Downloading file ${release_url}"
    curl -o "${local_archive}" -L ${release_url}

    if [[ $os == "windows" ]]; then
        unarch_dir="${LOCALAPPDATA}/gitleaks_${release_version}_${os}_${arch}"
        bin_dir="$HOME/bin"

        unzip -o "$HOME/${release_file}" -d $unarch_dir
        mkdir -p "$bin_dir"
        mv "${unarch_dir}/gitleaks.exe" "$bin_dir/gitleaks.exe"
        rm -rf "$unarch_dir"
        rm "$local_archive"
    elif [[ $os == "linux" ]]; then
        unarch_dir="$HOME/gitleaks_${release_version}_${os}_${arch}"
        bin_dir="/usr/local/bin"

        tar -xvf "$local_archive" -d $unarch_dir
        mv "${unarch_dir}/gitleaks" "$bin_dir/gitleaks"
        rm -rf "${unarch_dir}"
    else
        echo "[ERROR] No installation method for os: ${os}"
        exit 1
    fi
}


# echo $UNAME

if [[ $(which gitleaks) ]]; then
    echo "[OK] gitleaks installation found"
else
    install
fi


gitleaks detect --source . -v --no-git
# gitleaks detect --source . -v
