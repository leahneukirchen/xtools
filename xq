#!/bin/sh
# xq [-R] PKGS... - query information about XBPS package

totop() {
	sed -n 's/^'"$1"'/&/p;tk;H;:k;${x;s/\n//;p};d'
}

BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
ADDREPO="--repository=hostdir/binpkgs/$BRANCH
	--repository=../hostdir/binpkgs/$BRANCH
	--repository=../../hostdir/binpkgs/$BRANCH
	--repository=hostdir/binpkgs
	--repository=../hostdir/binpkgs
	--repository=../../hostdir/binpkgs"

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

