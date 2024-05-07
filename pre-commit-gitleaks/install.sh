#!/bin/sh
#!/bin/sh

set -e

gitleaks_release_version="8.18.2"
gitleaks_release_file="gitleaks_${gitleaks_release_version}_${os}_${arch}.zip"
gitleaks_release_url="https://github.com/gitleaks/gitleaks/releases/download/v${gitleaks_release_version}/${gitleaks_release_file}"

script_dir=$(dirname $0)

install_gitleaks() {
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
            exit 1 ;;
        # arm)    dpkg --print-architecture | grep -q "arm64" && arch="arm64" || arch="arm" ;;
    esac

    local_archive="$HOME/${gitleaks_release_file}"

    echo "[INFO] Downloading file ${gitleaks_release_url}"
    curl -o "${local_archive}" -L ${gitleaks_release_url}

    if [[ $os == "windows" ]]; then
        unarch_dir="${LOCALAPPDATA}/gitleaks_${gitleaks_release_version}_${os}_${arch}"
        bin_dir="$HOME/bin"

        unzip -o "$HOME/${gitleaks_release_file}" -d $unarch_dir
        mkdir -p "$bin_dir"
        mv "${unarch_dir}/gitleaks.exe" "$bin_dir/gitleaks.exe"
        rm -rf "$unarch_dir"
        rm "$local_archive"
    elif [[ $os == "linux" ]]; then
        unarch_dir="$HOME/gitleaks_${gitleaks_release_version}_${os}_${arch}"
        bin_dir="/usr/local/bin"

        tar -xvf "$local_archive" -d $unarch_dir
        mv "${unarch_dir}/gitleaks" "$bin_dir/gitleaks"
        rm -rf "${unarch_dir}"
    else
        echo "[ERROR] No installation method for os: ${os}"
        exit 1
    fi
}

install_hook() {

    if [[ -z $(git rev-parse --git-dir) ]]; then
        echo "[ERROR] Not inside git repository"
        exit 1
    fi

    hooks_dir="$script_dir/.git/hooks"
    hook_file="$hooks_dir/pre-commit"
    if [[ -d $hook_file ]]; then
        echo "[ERROR] Can not install script: directory with conflicting name already exists: $hook_file"
        exit 1
    fi

    file_name="hook.sh"
    curl -sLf -o $file_name "https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/main/pre-commit-gitleaks/$file_name"
    mv -i "$file_name" "$hook_file"
}


if [[ $(which gitleaks) ]]; then
    echo "[INFO] found gitleak installation"
else
    echo "[INFO] installing gitleak..."
    install_gitleaks
fi

install_hook
