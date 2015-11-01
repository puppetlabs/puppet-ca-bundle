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
USER        := $(shell id -u)
GROUP       := $(shell id -g)
PERMISSIONS := 0644
DESTDIR     := $(shell $(OPENSSL) version -d | $(CUT) -d '"' -f 2)
KEYSTORE    := puppet-cacerts
KEYTOOL     := $(shell which keytool)

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

keystore:
ifdef KEYTOOL
	for pem_file in ./*.pem; do \
		/bin/echo yes | $(KEYTOOL) -import \
			-alias $(basename "$${pem_file}" .pem) \
			-keystore $(KEYSTORE) \
			-storepass 'changeit' \
			-file "$${pem_file}" ; \
	done
	$(CP) $(KEYSTORE) $(DESTDIR)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(KEYSTORE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(KEYSTORE)
else
	$(warning not creating keystore, keytool cannot be found)
endif
