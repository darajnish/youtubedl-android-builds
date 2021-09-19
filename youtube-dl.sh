#!/bin/sh

if [[ -z "$YOUTUBEDL_ROOT" ]]; then
	export YOUTUBEDL_ROOT="$(realpath $(dirname ${0})/..)"
fi

_CACHEDIR="${YOUTUBEDL_ROOT}/cache"
_LIBDIR="${YOUTUBEDL_ROOT}/lib"
_BINDIR="${YOUTUBEDL_ROOT}/bin"
_SSLFILE="${YOUTUBEDL_ROOT}/etc/tls/cert.pem"
_YOUTUBEDL="${YOUTUBEDL_ROOT}/lib/youtube-dl/youtube-dl"

export PATH="$PATH:${_BINDIR}"
export LD_LIBRARY_PATH="${_LIBDIR}"
export PYTHONHOME="${YOUTUBEDL_ROOT}"
export SSL_CERT_FILE="${_SSLFILE}"

if [[ ! -d "${_CACHEDIR}" ]]; then
	mkdir "${_CACHEDIR}"
fi

python "${_YOUTUBEDL}" --cache-dir "${_CACHEDIR}" ${@}
