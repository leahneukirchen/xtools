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
	# Tries to avoid prompting for password unless absolutely necessary
	if [ "$(id -u)" = "0" ]; then
		return
	fi
	xi_sudo=0 xi_doas=0
	if command -v sudo >/dev/null; then
		xi_sudo=1
	fi
	if command -v doas >/dev/null && [ -f /etc/doas.conf ] && [ "$(doas -C /etc/doas.conf xbps-install)" != deny ]; then
		xi_doas=1
	fi
	case "$xi_sudo$xi_doas" in
		(00) echo su ;;
		(01) echo doas ;;
		(10) echo sudo ;;
		(11)
			if [ "$(doas -C /etc/doas.conf xbps-install)" = "permit nopass" ]; then
				echo doas
			elif sudo -l xbps-install >/dev/null; then
				echo sudo
			else
				echo su
			fi
	esac
	unset -v xi_sudo xi_doas
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
