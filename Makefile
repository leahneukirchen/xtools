PREFIX=${HOME}
DESTDIR=

all:

install:
	for f in x*[^~]; do install -Dm0755 $$f $(DESTDIR)$(PREFIX)/bin/$$f; done
	install -Dm644 _xtools /usr/share/zsh/site-functions/_xtools

