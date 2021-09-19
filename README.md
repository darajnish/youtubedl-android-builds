#  youtube-dl android builds

Scripts to build binary packages to run youtube-dl (with FFmpeg) on Android, with Python and just the required dependencies. These scripts use the [termux build system](https://github.com/termux/termux-packages) to build the entire required packages and then the unnecessary packages and the files are trimmed off to get just the required minimal build. The list of required packages to run `youtube-dl` are in the file `required-packages.txt`, which is used by the script to trim off unnecessary packages for our build.

Note: These packages work only for Android 5 (Lollipop) and above.

##  Running

####  Requirements

- [cURL](https://curl.haxx.se/)
- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- A GNU/Linux System

####  Steps

Once, the above requirements are met, make sure you've an internet connection and the docker service is running in your system. Remove any previous `termux/package-builder` container, if you have already in your docker (if you were using the termux build system previously).

Other than all the above, you're good to go. Just start the build by running the script `autobuild.sh`, the script will do the rest and create a build for each of the [Android ABIs](https://developer.android.com/ndk/guides/abis) and place the respective packages in the same directory.

```bash
./autobuild.sh
```

However, if you don't want to use `autobuild.sh` or you just want to build just for a single architecture, then it can be achieved using the following steps.

First, clone the termux build system repository
```bash
git clone "https://github.com/termux/termux-packages"
```
Download the latest youtube-dl script
```bash
curl -L "https://yt-dl.org/downloads/latest/youtube-dl" -o "youtube-dl"
```

Copy the required scripts into `termux-packages`
```bash
cp -v build-youtubedl.sh required-packages.txt youtube-dl.sh youtube-dl termux-packages
```

Make sure the docker service is running and switch to termux docker container
```bash
cd termux-packages && ./scripts/run-docker.sh
```

Create a build directory and change into it
```bash
mkdir -v build
```

Run `build-youtubedl.sh` to start building the entire required packages, change the value of ARCH variable to the android architecture (`x86_64`, `i686`, `arm`, `aarch64`) for which you want to build the packages. For, [`armeabi-v7a`](https://developer.android.com/ndk/guides/abis#v7a) ARCH=arm, and for [`arm64-v8a`](https://developer.android.com/ndk/guides/abis#arm64-v8a) ARCH=aarch64, and for [`x86`](https://developer.android.com/ndk/guides/abis#x86) ARCH=i686 and for [`x86_64`](https://developer.android.com/ndk/guides/abis#86-64) ARCH=x86_64
```bash
ARCH=arm ../build-youtubedl.sh build
```
Similarly, extract the required packages
```bash
ARCH=arm ../build-youtubedl.sh extract
```
And the same way, build the packages
```bash
ARCH=arm ../build-youtubedl.sh package
```
If you need to clean the current `build`directory and the build environment
```bash
ARCH=arm ../build-youtubedl.sh clean
```

Exit from the termux build system
```bash
exit
```
Finally, you have a compressed tarball package for running youtube-dl on android, you may copy it out to the main directory.
```bash
cp -v youtubedl-arm.tar.xz ..
```


Extracting the tarball and running youtube-dl on an android system is easy and can be done with the help of busybox tar applet.
Assuming, we've copied busybox and the package into our android system at `/data/local/tmp` we can run youtube-dl as follows,
```bash
cd /data/local/tmp
chmod 755 busybox
mkdir test
cd test
../busybox tar -xf ../youtubedl-arm.tar.xz
./usr/bin/youtube-dl "https://www.youtube.com/watch?v=aqz-KE-bpKQ"
```

##  Credits

- [youtubedl-android guide](https://github.com/yausername/youtubedl-android/blob/master/BUILD_FFMPEG.md) for giving an overall insight of how it's done
- [Termux Wiki](https://wiki.termux.com/wiki/Building_packages) for providing a detailed guide on how to build packages using the termux build system

##  License

The scripts are under under [GPLv3](LICENSE)
