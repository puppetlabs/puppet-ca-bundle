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
KEYSTOREFIPS:= $(KEYSTORE)-fips
STORETYPE   := JKS
KEYTOOL     := $(shell which keytool)
BCFIPS      := /opt/puppetlabs/share/java/bc-fips.jar

.DEFAULT_GOAL := install

clean:
	$(RM) $(BUNDLE)
	$(RM) ./pl_*.pem
	$(RM) $(KEYSTORE) $(KEYSTOREFIPS)

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
	if [ ! -e $(BCFIPS) ]; then \
		echo "not creating FIPS keystore, $(BCFIPS) is missing. Install the latest version from https://builds.delivery.puppetlabs.net/pe-bouncy-castle-jars/"; \
		exit 1; \
	fi
	for pem_file in ./pl_*.pem; do \
		/bin/echo yes | $(KEYTOOL) -import \
			-alias $$(basename "$${pem_file}" .pem | sed -e 's/^pl_//') \
			-keystore $(KEYSTORE) \
			-storetype $(STORETYPE) \
			-storepass 'changeit' \
			-file "$${pem_file}" ; \
	done
	for pem_file in ./pl_*.pem; do \
		/bin/echo yes | $(KEYTOOL) -import \
			-alias $$(basename "$${pem_file}" .pem | sed -e 's/^pl_//') \
			-keystore $(KEYSTOREFIPS) \
			-storetype BCFKS \
			-storepass 'changeit' \
			-providerclass org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider \
			-providerpath $(BCFIPS) \
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
	./remove_unwanted_files.sh

install-bundle:
	$(MKDIR) $(DESTDIR)
	$(CP) $(BUNDLE) $(DESTDIR)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(BUNDLE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(BUNDLE)

install: install-bundle
	$(CP) $(KEYSTORE) $(DESTDIR)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(KEYSTORE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(KEYSTORE)

install-fips: install-bundle
	$(CP) $(KEYSTOREFIPS) $(DESTDIR)/$(KEYSTORE)
	$(CHOWN) $(USER):$(GROUP) $(DESTDIR)/$(KEYSTORE)
	$(CHMOD) $(PERMISSIONS) $(DESTDIR)/$(KEYSTORE)

uninstall:
	$(RM) $(DESTDIR)/$(BUNDLE)
	$(RM) $(DESTDIR)/$(KEYSTORE)
