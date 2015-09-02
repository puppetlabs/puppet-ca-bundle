## Puppet Labs is now shipping a CA cert bundle!

The ["canonical", up-to-date Cert Authority bundle](https://github.com/bagder/ca-bundle/) currently provides 155 Root certificates. Puppet really only needs about 10% of them out of the box. So we're going to provide a stripped down Cert Authority bundle that allows connecting to the following services out of the box:

- Puppet Forge
- Ruby Gems
- Amazon Web Services
- Microsoft Azure

### Verisign Root Certificates (Amazon Web Services)

Verisign (a Symantec company) provides [a complete bundle](https://www.symantec.com/page.jsp?id=roots) due to the comparatively complicated way their CA has always functioned. These certs are provided under The [Verisign Root Certificate License](https://www.symantec.com/content/en/us/about/media/repository/root-certificate-license-agreement.pdf), which we are not required to sign (as distribution counts as acceptance of the terms).

    Class 1 Public Primary Certification Authority - G2.pem
    Class 1 Public Primary Certification Authority.pem
    Class 2 Public Primary Certification Authority - G2.pem
    Class 2 Public Primary Certification Authority.pem
    Class 3 Public Primary Certification Authority - G2.pem
    Class 3 Public Primary Certification Authority.pem
    Class 4 Public Primary Certification Authority - G2.pem
    Class-2-Public-Primary-Certification-Authority-G2.pem
    PCA_1_G6.pem
    PCA_2_G6.pem
    VeriSign Class 1 Public Primary Certification Authority - G3.pem
    VeriSign Class 2 Public Primary Certification Authority - G3.pem
    VeriSign Class 3 Public Primary Certification Authority - G3.pem
    VeriSign Class 3 Public Primary Certification Authority - G4.pem
    VeriSign Class 3 Public Primary Certification Authority - G5.pem
    VeriSign Class 4 Public Primary Certification Authority - G3.pem
    VeriSign Universal Root Certification Authority.pem
    VeriSign-Class-1-Public-Primary-Certification-Authority-G3.pem
    VeriSign-Class-2-Public-Primary-Certification-Authority-G3.pem
    VeriSign-Class-3-Public-Primary-Certification-Authority-G4.pem
    VeriSign-Class-4-Public-Primary-Certification-Authority-G3.pem
    VeriSign-Universal-Root-Certification-Authority.pem

### Microsoft Root Certificate (Microsoft Azure)

In 2013, Microsoft [migrated all of their SSL certificates](http://azure.microsoft.com/en-us/blog/windows-azure-root-certificate-migration/) to new ones signed by the Baltimore Cybertrust Root certificate.

    Baltimore Cybertrust Root.pem
    
### Puppet Labs Root Certificates (Puppet Forge, Ruby Gems)

Coincidentally, Rubygems.org uses the AddTrust root certificates, so these certificates also provide TLS validation for `gem`.

    AddTrust Class 1 CA Root.pem
    AddTrust External CA Root.pem
    AddTrust Public CA Root.pem
    AddTrust Qualified CA Root.pem
    GeoTrust Global CA.pem
    GeoTrust Primary Certification Authority - G2.pem
    GeoTrust Primary Certification Authority - G3.pem
    GeoTrust Primary Certification Authority.pem
    StartCom Certification Authority 1.pem
    StartCom Certification Authority 2.pem
    StartCom Certification Authority G2.pem
    UTN-USERFirst-Hardware.pem    
