PATH    := /bin:/usr/bin:/usr/local/bin
SHELL   := /bin/sh
OPENSSL := openssl
CAT     := cat
CUT     := cut
MKDIR   := mkdir -p
CP      := cp -f
RM      := rm -rf
BUNDLE  := ca-bundle.crt
DESTDIR := $(shell $(OPENSSL) version -d | $(CUT) -d '"' -f 2)/certs

.DEFAULT_GOAL := bundle

clean:
	$(RM) $(BUNDLE)

bundle:
	$(CAT) ./*.pem > $(BUNDLE)

install: bundle
	$(MKDIR) $(DESTDIR)
	$(CP) $(BUNDLE) $(DESTDIR)

uninstall:
	$(RM) $(DESTDIR)/$(BUNDLE)
