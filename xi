#!/bin/sh
# xi PKGS... - like xbps-install -S, but take cwd repo and sudo/su into account

BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
ADDREPO="
	--repository=hostdir/binpkgs/$BRANCH
	--repository=../hostdir/binpkgs/$BRANCH
	--repository=../../hostdir/binpkgs/$BRANCH
	--repository=hostdir/binpkgs/$BRANCH/nonfree
	--repository=../hostdir/binpkgs/$BRANCH/nonfree
	--repository=../../hostdir/binpkgs/$BRANCH/nonfree
	--repository=hostdir/binpkgs/$BRANCH/multilib
	--repository=../hostdir/binpkgs/$BRANCH/multilib
	--repository=../../hostdir/binpkgs/$BRANCH/multilib
	--repository=hostdir/binpkgs/$BRANCH/multilib/nonfree
	--repository=../hostdir/binpkgs/$BRANCH/multilib/nonfree
	--repository=../../hostdir/binpkgs/$BRANCH/multilib/nonfree
	--repository=hostdir/binpkgs/$BRANCH/debug
	--repository=../hostdir/binpkgs/$BRANCH/debug
	--repository=../../hostdir/binpkgs/$BRANCH/debug
	--repository=hostdir/binpkgs
	--repository=../hostdir/binpkgs
	--repository=../../hostdir/binpkgs
	--repository=hostdir/binpkgs/nonfree
	--repository=../hostdir/binpkgs/nonfree
	--repository=../../hostdir/binpkgs/nonfree
	--repository=hostdir/binpkgs/multilib
	--repository=../hostdir/binpkgs/multilib
	--repository=../../hostdir/binpkgs/multilib
	--repository=hostdir/binpkgs/multilib/nonfree
	--repository=../hostdir/binpkgs/multilib/nonfree
	--repository=../../hostdir/binpkgs/multilib/nonfree
	--repository=hostdir/binpkgs/debug
	--repository=../hostdir/binpkgs/debug
	--repository=../../hostdir/binpkgs/debug
"

SUDO=
if command -v sudo >/dev/null &&
   sudo -l | grep -q -e ' ALL$' -e xbps-install; then
	SUDO=sudo
elif [ "$(whoami)" != root ]; then
	SUDO='su root -c '\''"$@"'\'' -- -'
fi

$SUDO xbps-install $ADDREPO -S "$@"
