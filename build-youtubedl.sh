#!/bin/bash

if [[ -z "$ARCH" ]]; then
	export ARCH=arm #x86_64, i686, arm, aarch64
fi

PKGFILE="../required-packages.txt"
YOUTUBEDL="../youtube-dl"
YOUTUBEDLSH="../youtube-dl.sh"
PKGDIR="../ffmpeg-packges-${ARCH}"
PREFIX="/data/data/sng.darajnish.ytube_dl/files/"


rm_obvious () {
	rm -rvf data/data/com.termux/files/usr/include/
	rm -rvf data/data/com.termux/files/usr/lib/pkgconfig/
	rm -rvf data/data/com.termux/files/usr/lib/cmake/
	rm -rvf data/data/com.termux/files/usr/lib/glib-2.0
	rm -rvf data/data/com.termux/files/usr/bin/
	rm -rvf data/data/com.termux/files/usr/share
	rm -rvf data/data/com.termux/files/usr/etc/fonts/conf.d/
}

build() {
	export TERMUX_ARCH="${ARCH}"
	export TERMUX_PREFIX="${PREFIX}/usr"
	export TERMUX_ANDROID_HOME="${PREFIX}/home"

	_CDIR="$(pwd)"
	cd ..
	./clean.sh
	./build-package.sh librav1e
	./build-package.sh ffmpeg
	./build-package.sh python
	cd "${_CDIR}"
	mv -v ../output "${PKGDIR}"
}

extract_clean() {
	if [[ ! -f "$PKGFILE" ]]; then
		echo "Error: pkgfile.txt not found in the current directory!"
		exit 2
	fi

	if [[ ! -d "$PKGDIR" ]]; then
		echo "Error: The packages directory ${PKGDIR} doesn't exist!"
		exit 2
	fi

	if [[ $(ls -l | head -n1) != 'total 0' ]]; then
		echo "Error: The directory must be empty!"
		exit 2
	fi

	while read line; do
		if   [[ $line == 'ffmpeg'* ]]; then
			dpkg-deb -xv "${PKGDIR}/${line}_${ARCH}.deb" .
			rm -rvf data/data/com.termux/files/usr/include/
			rm -rvf data/data/com.termux/files/usr/share/doc/
			rm -rvf data/data/com.termux/files/usr/share/man/
			rm -rvf data/data/com.termux/files/usr/lib/pkgconfig/
			rm -rvf data/data/com.termux/files/usr/share/ffmpeg/examples/
		elif [[ $line == 'python'* ]]; then
			dpkg-deb -xv "${PKGDIR}/${line}_${ARCH}.deb" .
			rm -rvf data/data/com.termux/files/usr/lib/pkgconfig/
			rm -rvf data/data/com.termux/files/usr/share/
			rm -rvf data/data/com.termux/files/usr/include/
			rm -rvf data/data/com.termux/files/usr/bin/2to3*
			rm -rvf data/data/com.termux/files/usr/bin/pydoc*
			rm -rvf data/data/com.termux/files/usr/bin/python*-config
			rm -rvf data/data/com.termux/files/usr/lib/python3.9/unittest
			rm -rvf data/data/com.termux/files/usr/lib/python3.9/site-packages/xcbgen/
			rm -rvf data/data/com.termux/files/usr/lib/python3.9/ensurepip/
			rm -rvf data/data/com.termux/files/usr/lib/python3.9/lib2to3/
			rm -rvf data/data/com.termux/files/usr/lib/python3.9/distutils/
			rm -rvf data/data/com.termux/files/usr/lib/python3.9/pydoc_data/
			rm -rvf data/data/com.termux/files/usr/lib/python3.9/pydoc.py
		elif [[ $line == 'ca-certificates'* ]]; then
			dpkg-deb -xv "${PKGDIR}/${line}_all.deb" .
			rm_obvious
		else
			dpkg-deb -xv "${PKGDIR}/${line}_${ARCH}.deb" .
			rm_obvious
		fi
	done < "${PKGFILE}"

	cp -v /home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux/${ARCH}/libomp.so data/data/com.termux/files/usr/lib/

	mkdir -v "data/data/com.termux/files/usr/lib/youtube-dl"
	cp -v "${YOUTUBEDL}" "data/data/com.termux/files/usr/lib/youtube-dl"

	cp -v "${YOUTUBEDLSH}" "data/data/com.termux/files/usr/bin/youtube-dl"
	chmod +x "data/data/com.termux/files/usr/bin/youtube-dl"
}

package() {
	#export XZ_OPT=-e9
	cd "data/data/com.termux/files"
	XZ_OPT=-e9 tar -acvf "../../../../../youtubedl-${ARCH}.tar.xz" *
	cd "../../../../"
}

clean() {
	rm -rvf *
	../clean.sh
}

show_help() {
cat << "EOF"

Usage: build-youtubedl.sh [build | extract | package]

	build	Execute the build task
	extract	Execute extraction and cleaning
	package	Execute the packaging task
	clean	Cleans off the current directory

EOF
}


if [[ "$1" == "build" ]]; then
	build
elif [[ "$1" == "extract" ]]; then
	extract_clean
elif [[ "$1" == "package" ]]; then
	package
elif [[ "$1" == "clean" ]]; then
	clean
elif [[ "$1" == "--help"  ]]; then
	show_help
else
	show_help
fi

