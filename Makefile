PREFIX=${HOME}
DESTDIR=

all:

install:
	for f in x*[!~1]; do install -Dm0755 $$f $(DESTDIR)$(PREFIX)/bin/$$f; done
	install -Dm644 _xtools $(DESTDIR)/$(PREFIX)/share/zsh/site-functions/_xtools
	install -Dm644 xtools.1 $(DESTDIR)/$(PREFIX)/share/man/man1/xtools.1
	for f in x*[!~1]; do ln -sf xtools.1 $(DESTDIR)$(PREFIX)/share/man/man1/$$f.1; done

README: xtools.1
	mandoc -Tutf8 $< | col -bx >$@
