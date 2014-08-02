#!/bin/sh
# xq PKGS... - query information about XBPS package

BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
ADDREPO="--repository=hostdir/binpkgs/$BRANCH
	--repository=../hostdir/binpkgs/$BRANCH
	--repository=../../hostdir/binpkgs/$BRANCH"

for pkg; do
	xbps-query $ADDREPO -S "$pkg" |
		sed -n 's/^short_desc/&/p;tk;H;:k;${x;s/\n//;p};d' |
		sed -n 's/^pkgver/&/p;tk;H;:k;${x;s/\n//;p};d'
	xbps-query $ADDREPO -x "$pkg" | sed 's/^/	/;1s/^/depends:\n/'
	REVDEP=$(xbps-query -X "$pkg" | sed 's/^/	/' )
	if [ "$REVDEP" ]; then
		printf "%s\n" "required-by:" "$REVDEP"
	fi
done

