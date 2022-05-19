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
STORETYPE   := JKS
KEYTOOL     := $(shell which keytool)

.DEFAULT_GOAL := install

clean:
	$(RM) $(BUNDLE)
	$(RM) ./pl_*.pem
	$(RM) $(KEYSTORE)

bundle:
	$(CAT) ./*.crt > $(BUNDLE)

pemify:
	for crt_file in ./*.crt; do \
		$(OPENSSL) x509 -in "$${crt_file}" \
		-out "pl_"$$(basename "$${crt_file}" .crt )".pem" \
		-outform pem ; \
	done

keystore: pemify
ifdef KEYTOOL
	for pem_file in ./pl_*.pem; do \
		/bin/echo yes | $(KEYTOOL) -import \
			-alias $$(basename "$${pem_file}" .pem | sed -e 's/^pl_//') \
			-keystore $(KEYSTORE) \
			-storetype $(STORETYPE) \
			-storepass 'changeit' \
			-file "$${pem_file}" ; \
	done
	$(RM) ./pl_*.pem
else
	$(error not creating keystore, keytool cannot be found)
endif

prepare: clean bundle keystore

refresh-certs: clean
	$(RM) *.crt
	perl mk-ca-bundle.pl
	python certdata2pem.py
	$(RM) -f *.p11-kit
	./remove_unwanted_files.sh

install:
	$(MKDIR) $(DESTDIR)
	$(CP) $(BUNDLE) $(DESTDIR)
	$(CP) $(KEYSTORE) $(DESTDIR)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(BUNDLE)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(KEYSTORE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(BUNDLE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(KEYSTORE)

uninstall:
	$(RM) $(DESTDIR)/$(BUNDLE)
	$(RM) $(DESTDIR)/$(KEYSTORE)
