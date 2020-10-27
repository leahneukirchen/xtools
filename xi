#!/bin/sh
# xi PKGS... - like xbps-install -S, but take cwd repo and sudo/su into account

BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
if [ -n "$XBPS_HOSTDIR" ]; then
	XBPS_BINPKGS="$XBPS_HOSTDIR/binpkgs"
else
	XBPS_DISTDIR="$(xdistdir 2>/dev/null)" || XBPS_DISTDIR=.
	XBPS_BINPKGS="$XBPS_DISTDIR/hostdir/binpkgs"
fi
ADDREPO="
	--repository=$XBPS_BINPKGS/$BRANCH
	--repository=$XBPS_BINPKGS/$BRANCH/nonfree
	--repository=$XBPS_BINPKGS/$BRANCH/multilib
	--repository=$XBPS_BINPKGS/$BRANCH/multilib/nonfree
	--repository=$XBPS_BINPKGS/$BRANCH/debug
	--repository=$XBPS_BINPKGS
	--repository=$XBPS_BINPKGS/nonfree
	--repository=$XBPS_BINPKGS/multilib
	--repository=$XBPS_BINPKGS/multilib/nonfree
	--repository=$XBPS_BINPKGS/debug
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
