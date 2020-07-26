#!/bin/sh
# xi PKGS... - like xbps-install -S, but take cwd repo and sudo/su into account

BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
XBPS_DISTDIR="$(xdistdir 2>/dev/null)" || XBPS_DISTDIR=.
ADDREPO="
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/$BRANCH
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/$BRANCH/nonfree
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/$BRANCH/multilib
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/$BRANCH/multilib/nonfree
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/$BRANCH/debug
	--repository=$XBPS_DISTDIR/hostdir/binpkgs
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/nonfree
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/multilib
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/multilib/nonfree
	--repository=$XBPS_DISTDIR/hostdir/binpkgs/debug
"

SUDO=
if command -v sudo >/dev/null &&
   sudo -l | grep -q -e ' ALL$' -e xbps-install; then
	SUDO=sudo
elif command -v doas >/dev/null && [ -f /etc/doas.conf ]; then
	SUDO=doas
elif [ "$(whoami)" != root ]; then
	SUDO='su root -c '\''"$@"'\'' -- -'
fi

$SUDO xbps-install $ADDREPO -S "$@"
if [ $? -eq 16 ]; then
	$SUDO xbps-install -u xbps
	$SUDO xbps-install $ADDREPO -S "$@"
fi
