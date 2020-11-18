#!/bin/sh
# xq [-R] PKGS... - query information about XBPS package

totop() {
	sed -n 's/^'"$1"'/&/p;tk;H;:k;${x;s/\n//;p};d'
}

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

R=
if [ "$1" = -R ]; then
	R=-R
	shift
fi

for pkg; do
	xbps-query $ADDREPO -S "$pkg" |
		totop short_desc |
		totop pkgver
	xbps-query $ADDREPO $R -x "$pkg" | sed 's/^/	/;1s/^/depends:\n/'
	REVDEP=$(xbps-query $R -X "$pkg" | sed 's/^/	/' )
	if [ "$REVDEP" ]; then
		printf "%s\n" "required-by:" "$REVDEP"
	fi
done

