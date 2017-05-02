PREFIX=${HOME}
DESTDIR=

all:

install:
	for f in x*[^~]; do install -Dm0755 $$f $(DESTDIR)$(PREFIX)/bin/$$f; done
	install -Dm644 _xtools $(DESTDIR)/$(PREFIX)/share/zsh/site-functions/_xtools

README: xtools.1
	mandoc -Tutf8 $< | col -bx >$@
