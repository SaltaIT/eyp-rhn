# rhn

![PRs Welcome](https://img.shields.io/badge/prs-welcome-brightgreen.svg)

**NTTCom-MS/eyp-rhn**: [![Build Status](https://travis-ci.org/NTTCom-MS/eyp-rhn.png?branch=master)](https://travis-ci.org/NTTCom-MS/eyp-rhn)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rhn](#setup)
    * [What rhn affects](#what-rhn-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rhn](#beginning-with-rhn)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A one-maybe-two sentence summary of what the module does/what problem it solves.
This is your 30 second elevator pitch for your module. Consider including
OS/Puppet version it works with.

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What rhn affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with rhn

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

reposync scripts:

```yaml
yumreposyncs:
  'rhel-7-server-rpms':
    repo_path: '/var/www/rhelmirror'
    max_iterations_yum_pid: 870
    delete: true
    newest_only: true
    cron_ensure: 'absent'
  'rhel-7-server-supplementary-rpms':
    repo_path: '/var/www/rhelmirror'
    max_iterations_yum_pid: 870
    delete: true
    newest_only: true
    cron_ensure: 'absent'
  'rhel-7-server-optional-rpms':
    repo_path: '/var/www/rhelmirror'
    max_iterations_yum_pid: 870
    delete: true
    newest_only: true
    cron_ensure: 'absent'
```

webserver nginx for local mirrors:

```yaml
classes:
  - nginx
nginx::add_default_vhost: false
nginxvhosts:
  'rhelmirror':
    default: true
    port: 8080
nginxstubstatus:
  'rhelmirror':
    port: 8080
```

client config:

```yaml
rhnrepos:
  'rhel-7-server-rpms':
    ensure: 'absent'
  'rhel-7-server-supplementary-rpms':
    ensure: 'absent'
  'rhel-7-server-optional-rpms':
    ensure: 'absent'
yumrepos:
  'local-rhel-7-server-rpms':
    ensure: 'present'
    baseurl: 'http://localhost:8080/rhel-7-server-rpms'
    gpgcheck: true
    descr: 'local mirror - Red Hat Enterprise Linux 7 Server (RPMs)'
    enabled: true
  'local-rhel-7-server-supplementary-rpms':
    ensure: 'present'
    baseurl: 'http://localhost:8080/rhel-7-server-supplementary-rpms'
    gpgcheck: true
    descr: 'local mirror - Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)'
    enabled: true
  'local-rhel-7-server-optional-rpms':
    ensure: 'present'
    baseurl: 'http://localhost:8080/rhel-7-server-optional-rpms'
    gpgcheck: true
    descr: 'local mirror - Red Hat Enterprise Linux 7 Server - Optional (RPMs)'
    enabled: true
```

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

### subscription manager outputs

```
# subscription-manager status
+-------------------------------------------+
   System Status Details
+-------------------------------------------+
Overall Status: Current
```

```
# subscription-manager status
+-------------------------------------------+
   System Status Details
+-------------------------------------------+
Overall Status: Invalid

Red Hat Enterprise Linux Server:
- Not supported by a valid subscription.
```

##canvis rhel7

```
--- /etc/sysconfig/rhn/up2date	2016-10-04 13:00:27.495708479 +0100
+++ /tmp/puppet-file20161202-28229-1tomfwz	2016-12-02 15:13:38.878641298 +0000
@@ -1,23 +1,33 @@
 # Automatically generated Red Hat Update Agent config file, do not edit.
+# puppet managed file - do NOT edit
 # Format: 1.0
+tmpDir[comment]=Use this Directory to place the temporary transport files
+tmpDir=/tmp
+
 disallowConfChanges[comment]=Config options that can not be overwritten by a config update action
-disallowConfChanges=noReboot;sslCACert;useNoSSLForPackages;noSSLServerURL;serverURL
+disallowConfChanges=noReboot;sslCACert;useNoSSLForPackages;noSSLServerURL;serverURL;disallowConfChanges;
+
+skipNetwork[comment]=Skips network information in hardware profile sync during registration.
+skipNetwork=0

 networkRetries[comment]=Number of attempts to make at network connections before giving up
-networkRetries=5
+networkRetries=1
+
+hostedWhitelist[comment]=RHN Hosted URL's
+hostedWhitelist=

 enableProxy[comment]=Use a HTTP Proxy
 enableProxy=0

+writeChangesToLog[comment]=Log to /var/log/up2date which packages has been added and removed
+writeChangesToLog=0
+
 serverURL[comment]=Remote server URL
-serverURL=https://rhn.enterprise.verio.net/XMLRPC
+serverURL=https://xmlrpc.rhn.redhat.com/XMLRPC

 proxyPassword[comment]=The password to use for an authenticated proxy
 proxyPassword=

-noSSLServerURL[comment]=Remote server URL without SSL
-noSSLServerURL=http://rhn.enterprise.verio.net/XMLRPC
-
 proxyUser[comment]=The username for an authenticated proxy
 proxyUser=

@@ -25,7 +35,10 @@
 versionOverride=

 sslCACert[comment]=The CA cert used to verify the ssl server
-sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT
+sslCACert=/usr/share/rhn/RHNS-CA-CERT
+
+retrieveOnly[comment]=Retrieve packages only
+retrieveOnly=0

 debug[comment]=Whether or not debugging is enabled
 debug=0
@@ -33,9 +46,6 @@
 httpProxy[comment]=HTTP proxy in host:port format, e.g. squid.redhat.com:3128
 httpProxy=

-useNoSSLForPackages[comment]=Use the noSSLServerURL for package, package list, and header fetching
-useNoSSLForPackages=1
-
 systemIdPath[comment]=Location of system id
 systemIdPath=/etc/sysconfig/rhn/systemid

@@ -44,4 +54,3 @@

 noReboot[comment]=Disable the reboot actions
 noReboot=0
-
```

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

We are pushing to have acceptance testing in place, so any new feature must
have tests to check both presence and absence of any feature

### TODO

* manage proxy settings on **/etc/rhsm/rhsm.conf**

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
