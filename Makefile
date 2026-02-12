PREFIX ?= /usr/local

.PHONY: install uninstall test lint docs

install:
	PREFIX=$(PREFIX) ./install.sh

uninstall:
	rm -f $(PREFIX)/bin/linuxutils $(PREFIX)/bin/lu
	rm -rf $(PREFIX)/lib/linuxutils

test:
	bats tests

lint:
	shellcheck bin/linuxutils bin/lu lib/*.sh commands/*.sh install.sh scripts/install-via-curl.sh

docs:
	./scripts/generate-commands-doc.sh
