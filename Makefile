PREFIX ?= /usr/local
BINDIR := $(PREFIX)/bin
COMPLETIONDIR ?= /etc/bash_completion.d

SCRIPT := caddy-site.sh
COMPLETION := caddy-completion

all:
	@echo "Run 'make install' to install scripts and completion."

install:
	install -d "$(BINDIR)"
	install -m 0755 "$(SCRIPT)" "$(BINDIR)/caddy-ensite"
	ln -sf "caddy-ensite" "$(BINDIR)/caddy-dissite"

	install -d "$(COMPLETIONDIR)"
	install -m 0644 "$(COMPLETION)" "$(COMPLETIONDIR)/caddy"

uninstall:
	rm -f "$(BINDIR)/caddy-ensite" "$(BINDIR)/caddy-dissite"
	rm -f "$(COMPLETIONDIR)/caddy"

