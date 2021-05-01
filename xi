#!/bin/sh
# xi PKGS... - like xbps-install -S, but take cwd repo and sudo/su into account

if [ -n "$XBPS_HOSTDIR" ]; then
	XBPS_BINPKGS="$XBPS_HOSTDIR/binpkgs"
else
	XBPS_DISTDIR="$(xdistdir 2>/dev/null)" || XBPS_DISTDIR=.
	XBPS_BINPKGS="$XBPS_DISTDIR/hostdir/binpkgs"
fi

set -- \
	--repository="$XBPS_BINPKGS" \
	--repository="$XBPS_BINPKGS/nonfree" \
	--repository="$XBPS_BINPKGS/multilib" \
	--repository="$XBPS_BINPKGS/multilib/nonfree" \
	--repository="$XBPS_BINPKGS/debug" \
	"$@"

if BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null) && [ -n "$BRANCH" ]; then
	set -- \
		--repository="$XBPS_BINPKGS/$BRANCH" \
		--repository="$XBPS_BINPKGS/$BRANCH/nonfree" \
		--repository="$XBPS_BINPKGS/$BRANCH/multilib" \
		--repository="$XBPS_BINPKGS/$BRANCH/multilib/nonfree" \
		--repository="$XBPS_BINPKGS/$BRANCH/debug" \
		"$@"
fi

which_sudo() {
	if command -v sudo >/dev/null && sudo -l | grep -q -e ' ALL$' -e xbps-install; then
		echo sudo
	elif command -v doas >/dev/null && [ -f /etc/doas.conf ]; then
		echo doas
	elif [ "$(id -u)" != 0 ]; then
		echo su
	fi
}

do_install() {
	if [ "$SUDO" = su ]; then
		su root -c 'xbps-install "$@"' -- sh "$@"
	else
		$SUDO xbps-install "$@"
	fi
}

SUDO=$(which_sudo)
do_install -S "$@"
status=$?
if [ $status -eq 16 ]; then
	do_install -u xbps &&
	do_install -S "$@"
else
	exit $status
fi
