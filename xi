#!/bin/sh
# xi PKGS... - like xbps-install -S, but take cwd repo and sudo/su into account

BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
ADDREPO="--repository=hostdir/binpkgs/$BRANCH
	--repository=../hostdir/binpkgs/$BRANCH
	--repository=../../hostdir/binpkgs/$BRANCH
	--repository=hostdir/binpkgs
	--repository=../hostdir/binpkgs
	--repository=../../hostdir/binpkgs"

SUDO=
if command -v sudo >/dev/null &&
   sudo -l | grep -q -e ' ALL$' -e xbps-install; then
	SUDO=sudo
elif [ "$(whoami)" != root ]; then
	SUDO='su root -c '\''"$@"'\'' -- -'
fi

$SUDO xbps-install $ADDREPO -S "$@"
