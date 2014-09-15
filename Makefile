PREFIX=${HOME}
DESTDIR=

all:

install:
	for f in x*[^~]; do install -Dm0755 $$f $(DESTDIR)$(PREFIX)/bin/$$f; done

