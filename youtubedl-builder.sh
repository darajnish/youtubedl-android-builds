#!/bin/bash

mkdir -pv build
cd build

for arch in x86_64 i686 arm aarch64 ; do
	echo "=> Building for ${arch}"
    
	export ARCH="${arch}"
	../build-youtubedl.sh build
	../build-youtubedl.sh extract
	../build-youtubedl.sh package
	../build-youtubedl.sh clean
done
