PATH        := /bin:/usr/bin:/usr/local/bin
SHELL       := /bin/sh
OPENSSL     := openssl
CAT         := cat
CUT         := cut
MKDIR       := mkdir -p
CP          := cp -f
RM          := rm -rf
CHMOD       := chmod
CHOWN       := chown
BUNDLE      := cert.pem
USER        := $(shell id root |cut -d '=' -f2|cut -d '(' -f1)
GROUP       := $(shell id root |cut -d '=' -f3|cut -d '(' -f1)
PERMISSIONS := 0644
DESTDIR     := $(shell $(OPENSSL) version -d | $(CUT) -d '"' -f 2)

.DEFAULT_GOAL := bundle

clean:
	$(RM) $(BUNDLE)

bundle: clean
	$(CAT) ./*.pem > $(BUNDLE)

install: bundle
	$(MKDIR) $(DESTDIR)
	$(CP) $(BUNDLE) $(DESTDIR)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(BUNDLE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(BUNDLE)

uninstall:
	$(RM) $(DESTDIR)/$(BUNDLE)
