#!/bin/bash

DEPS=(curl git docker)

echo "=> Checking for required programs.."
for prog in ${DEPS[@]} ; do
    if ! ${prog} --version &>/dev/null ; then
        echo "${prog} is not installed! Install ${prog} first!"
        exit 2
    fi
done

if [[ ! -f "youtube-dl" ]]; then
    echo "=> Downloading the latest youtube-dl.."
    curl -L "https://yt-dl.org/downloads/latest/youtube-dl" -o "youtube-dl"
fi

echo "=> Preparing the build environment.."
git clone "https://github.com/termux/termux-packages"
cp -v youtubedl-builder.sh build-youtubedl.sh required-packages.txt youtube-dl.sh youtube-dl termux-packages

echo "=> Building starts.."
cd termux-packages
./scripts/run-docker.sh ./youtubedl-builder.sh

echo "=> Copying the built packages.."
cp -v youtubedl-x86_64.tar.xz youtubedl-i686.tar.xz youtubedl-arm.tar.xz youtubedl-aarch64.tar.xz ..

echo "=> Build Finished!"
