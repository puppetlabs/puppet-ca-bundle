# Puppet is now shipping a CA cert bundle!

The ["canonical", up-to-date Cert Authority bundle](https://curl.se/docs/caextract.html) currently provides many root certificates. We grab the Mozilla '[certdata.txt](https://mxr.mozilla.org/mozilla/source/security/nss/lib/ckfw/builtins/certdata.txt?raw=1)', use the 'certdata2pem.py' script from Red Hat to split that into PEM files, and remove anything that is untrusted
(i.e. with anything in the distrust= field), or doesn't explicitly list serverAuth in the openssl-trust field. The result lines up with the linked
[curl bundle above](https://github.com/bagder/ca-bundle/).

## Instructions

* Remove old .crt files: `rm *.crt`
* Download new certdata: `perl mk-ca-bundle.pl`
* Split into PEM files: `python certdata2pem.py`
* Run `./remove_unwanted_files.sh` to remove temporary and otherwise unwanted leftover files.

## Release

* Tag the puppet-ca-bundle project with the next version number
* Update the `configs/components/puppet-ca-bundle.json` file in puppet-runtime with the new version
* [An automatic tagging job](https://jenkins-master-prod-1.delivery.puppetlabs.net/view/puppet-runtime/job/platform_puppet-runtime-tagging_automatic-date-tag/) will tag puppet-runtime and kickoff build pipelines
