#!/bin/sh

install() {

    UNAME=$(uname)

    if [[ $UNAME == "Linux" ]]; then
        os="linux"
        echo "Linux"
    elif [[ $UNAME =~ (CYGWIN.*)|(MINGW.*) ]]; then
        os="windows"
        echo "Windows"
    else
        echo "Unsupported OS"
        exit -1
    fi

    architecture=""
    case $(uname -m) in
        i386)   arch="x32" ;;
        i686)   arch="x32" ;;
        x86_64) arch="x64" ;;
        *)
            echo "Unsupported architecture"
            exit -1
        # arm)    dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
    esac
    # TODO fail if architecture not found

    release_version="8.18.2"
    release_file="gitleaks_${release_version}_${os}_${arch}.zip"
    release_url="https://github.com/gitleaks/gitleaks/releases/download/v${release_version}/${release_file}"
    echo "Downloading file ${release_url}"
    curl -o "$HOME/${release_file}" -v -L ${release_url}

    if [[ $os == "windows" ]]; then
        dir="${LOCALAPPDATA}/gitleaks_${release_version}_${os}_${arch}"
        unzip -o "$HOME/${release_file}" -d $dir
    else
        dir="$HOME/gitleaks_${release_version}_${os}_${arch}"
        tar -xvf "$HOME/${release_file}" -d $dir
    fi
}

# echo $UNAME

if [[ !$(which gitleaks) ]]; then
    install
fi

d=$(pwd)
echo "Dir: ${d}"
