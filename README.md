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

A basic installation of NSD might look like the following.

```Puppet
include nsd
include nsd::remote
```

## Zone Management

Deploying zone files is simple.  A resource per zone is in order.  For example:

```Puppet
nsd::zone { 'lab.example.com':
  template => 'mysite/dns/lab.example.com.zone.erb'
}
```

The template string is passed directly to a `File` resource, so the same path
should apply that would be used in the `File` resource.

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


