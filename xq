#!/bin/sh
# xq PKGS... - query information about XBPS package

rmcol() {
	sed 's/\x1b\[[0-9;]*[mG]//g'
}

totop() {
	sed -n 's/^'"$1"'/&/p;tk;H;:k;${x;s/\n//;p};d'
}

BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
ADDREPO="--repository=hostdir/binpkgs/$BRANCH
	--repository=../hostdir/binpkgs/$BRANCH
	--repository=../../hostdir/binpkgs/$BRANCH"

for pkg; do
	xbps-query $ADDREPO -S "$pkg" | rmcol |
		totop short_desc |
		totop pkgver
	xbps-query $ADDREPO -x "$pkg" | sed 's/^/	/;1s/^/depends:\n/'
	REVDEP=$(xbps-query -X "$pkg" | sed 's/^/	/' )
	if [ "$REVDEP" ]; then
		printf "%s\n" "required-by:" "$REVDEP"
	fi
done

