## Puppet Labs is now shipping a CA cert bundle!

The ["canonical", up-to-date Cert Authority bundle](https://github.com/bagder/ca-bundle/) currently provides 155 Root certificates. We
are grabbing the Mozilla '[certdata.txt](https://mxr.mozilla.org/mozilla/source/security/nss/lib/ckfw/builtins/certdata.txt?raw=1)', using the 'certdata2pem.py' script from Red Hat to split that into PEM files, and removing anything that is untrusted
(i.e. with anything in the distrust= field), or doesn't explicitly list serverAuth in the openssl-trust field. The result lines up with the linked
[curl bundle above](https://github.com/bagder/ca-bundle/).

### Instructions
* Run `make refresh-certs` to download new certs, clean out those we do not want, and format them for this repo

### Release
* Tag the puppet-ca-bundle project with the next version number
* Update the `configs/components/puppet-ca-bundle.json` file in puppet-runtime with the new version
* [An automatic tagging job](https://jenkins-master-prod-1.delivery.puppetlabs.net/view/puppet-runtime/job/platform_puppet-runtime-tagging_automatic-date-tag/) will tag puppet-runtime and kickoff build pipelines

### Maintainers
release-team@puppetlabs.com

---

(c) 2016 Puppet Labs
