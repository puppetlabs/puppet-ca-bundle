# Puppet is now shipping a CA cert bundle!

The ["canonical", up-to-date Cert Authority bundle](https://curl.se/docs/caextract.html) currently provides many root certificates. We grab the Mozilla '[certdata.txt](https://mxr.mozilla.org/mozilla/source/security/nss/lib/ckfw/builtins/certdata.txt?raw=1)', use the 'certdata2pem.py' script from Red Hat to split that into PEM files, and remove anything that is untrusted
(i.e. with anything in the distrust= field), or doesn't explicitly list serverAuth in the openssl-trust field. The result lines up with the linked
[curl bundle above](https://github.com/bagder/ca-bundle/).

## Build Instructions

* Run `make refresh-certs` to download new certs, clean out those we do not want, and format them for this repo
* Run `make prepare` to create the cert bundle and keystore that will be installed in puppet-runtime builds

## Install Instructions

* Run `make install` to copy the already prepared PEM and JKS cert bundles and set permissions on the installed files.
* On FIPS hosts, run `make install-fips` instead.

## Release

* Tag the puppet-ca-bundle project with the next version number
* Update the `configs/components/puppet-ca-bundle.json` file in puppet-runtime with the new version
* [An automatic tagging job](https://jenkins-master-prod-1.delivery.puppetlabs.net/view/puppet-runtime/job/platform_puppet-runtime-tagging_automatic-date-tag/) will tag puppet-runtime and kickoff build pipelines
