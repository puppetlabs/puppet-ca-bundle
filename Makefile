PATH        := /opt/puppetlabs/puppet/bin:/bin:/usr/bin:/usr/local/bin
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
	$(RM) ./pl_*.pem
	$(RM) $(KEYSTORE)

bundle: clean
	$(CAT) ./*.crt > $(BUNDLE)

pemify:
	for crt_file in ./*.crt; do \
		$(OPENSSL) x509 -in "$${crt_file}" \
		-out "pl_"$$(basename "$${crt_file}" .crt )".pem" \
		-outform pem ; \
	done

install: bundle
	$(MKDIR) $(DESTDIR)
	$(CP) $(BUNDLE) $(DESTDIR)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(BUNDLE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(BUNDLE)

uninstall:
	$(RM) $(DESTDIR)/$(BUNDLE)

keystore: pemify
ifdef KEYTOOL
	for pem_file in ./pl_*.pem; do \
		/bin/echo yes | $(KEYTOOL) -import \
			-alias $$(basename "$${pem_file}" .pem | sed -e 's/^pl_//') \
			-keystore $(KEYSTORE) \
			-storepass 'changeit' \
			-file "$${pem_file}" ; \
	done
	$(CP) $(KEYSTORE) $(DESTDIR)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(KEYSTORE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(KEYSTORE)
else
	$(error not creating keystore, keytool cannot be found)
endif
