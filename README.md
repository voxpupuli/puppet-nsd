# Puppet powered DNS with NSD

[![Build Status](https://travis-ci.org/xaque208/puppet-nsd.png)](https://travis-ci.org/xaque208/puppet-nsd)

A Puppet module for the NSD authoritative resolver.

## Supported Platforms

* OpenBSD

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

At minimum you only need to include the class nsd. The defaults
are reasonable for running nsd on a stand-alone host.

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

The NSD remote controls the use of the nsd-control utility to
issue commands to the NSD daemon process.

```puppet
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

### With Hiera

You can use hiera-file or the template directory to store your
zone files that you want to have deployed to your NSD server.
The default is to pick them up from the modules template directory.

If you are using hiera, you may have the configuration like the
following example, additionally to the rest of your NSD configuration,
for one forward and one reverse zone:

```hiera
      nsd_config:
        templatestorage: hiera
        zones:
          intern:
            template: 'intern.zone'
          0.168.192.in-addr.arpa:
            template: '0.168.192.in-addr.arpa.zone'
```

The templatestorage parameter tells puppet to lookup the files
with hiera-file.

```puppet
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


## Contribute

Please help me make this module awesome!  Send pull requests and file issues.

