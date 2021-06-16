# Puppet powered DNS with NSD

[![CI](https://github.com/voxpupuli/puppet-nsd/actions/workflows/ci.yml/badge.svg)](https://github.com/voxpupuli/puppet-nsd/actions/workflows/ci.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/nsd.svg)](https://forge.puppetlabs.com/puppet/nsd)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/nsd.svg)](https://forge.puppetlabs.com/puppet/nsd)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/nsd.svg)](https://forge.puppetlabs.com/puppet/nsd)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/nsd.svg)](https://forge.puppetlabs.com/puppet/nsd)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-nsd)
[![AGPL v3 License](https://img.shields.io/github/license/voxpupuli/puppet-nsd.svg)](LICENSE)
[![Donated by Zach Leslie](https://img.shields.io/badge/donated%20by-Zach%20Leslie-fb7047.svg)](#copyright)

A Puppet module for the NSD authoritative resolver.

## Supported Platforms

* OpenBSD
* FreeBSD

## Requirements
The `concat` module must be installed. It can be obtained from Puppet Forge:

```
puppet module install puppetlabs/concat
```

Or add this line to your `Puppetfile` and deploy with [R10k](https://github.com/adrienthebo/r10k):

```Ruby
mod 'concat', :git => 'git://github.com/puppetlabs/puppetlabs-concat.git'
```

## Usage

## Server Setup

At minimum you only need to include the class nsd. The defaults are reasonable
for running nsd on a stand-alone host.

```Puppet
include nsd
include nsd::remote
```

If you have it running in pair with unbound, you may want to set the port nsd
listens on:

```Puppet
class { 'nsd':
  port => '5353',
}
```

### Remote Control

The NSD remote controls the use of the nsd-control utility to issue commands to
the NSD daemon process.

```Puppet
include nsd::remote
```

## Zone Management

### Without Hiera

Deploying zone files is simple.  A resource per zone is in order.  For example:

```Puppet
nsd::zone { 'lab.example.com':
  template => 'mysite/dns/lab.example.com.zone.erb'
}
```

The template string is passed directly to a `File` resource, so the same path
should apply that would be used in the `File` resource.

Use the `nsd::zonepurge` boolean to enable purging unmanaged zone files.

### With Hiera

You can use hiera-file or the template directory to store your zone files that
you want to have deployed to your NSD server.  The default is to pick them up
from the modules template directory.

If you are using hiera, you may have the configuration like the following
example, additionally to the rest of your NSD configuration, for one forward
and one reverse zone:

```yaml
nsd_config:
  templatestorage: hiera
  zones:
    intern:
      template: 'intern.zone'
    0.168.192.in-addr.arpa:
      template: '0.168.192.in-addr.arpa.zone'
```

The `templatestorage` parameter tells puppet to lookup the files with hiera-file.

```Puppet
$nsd_config = hiera_hash('nsd_config')
create_resources(nsd::zone, $nsd_config['zones'], { templatestorage => $nsd_config['templatestorage'] })
```

## Unbound Operation

When NSD and Unbound are combined, a robust DNS solution can emerge.  One
little convenience is to notify the Unbound service when any of the zone files
change.  Add the following to the top of the scope where your `nsd::zone`
resources are managed.

```Puppet
Nsd::Zone {
  notify => Service['unbound'],
}
```

## More information

You can find more information about NSD and its configuration at
[nlnetlabs.nl](http://www.nlnetlabs.nl/projects/nsd/).

## Transfer Notice

This plugin was originally authored by [Zach Leslie](https://forge.puppet.com/modules/zleslie).
The maintainer preferred that Puppet Community take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.

Previously: https://github.com/xaque208/puppet-nsd

## Contribute

Please help me make this module awesome!  Send pull requests and file issues.

## Copyright

Copyright Zach Leslie

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
