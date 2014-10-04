# NSD

## Usage

### Server Setup

At minimum you only need to include the class nsd. The defaults
are reasonable for running nsd on a stand-alone host. If you have
it running in pair with unbound, you may want to set the port
nsd listens on:

```puppet
    class { "nsd":
      port => "5353",
    }
```

### Remote Control

The NSD remote controls the use of the nsd-control utility to
issue commands to the NSD daemon process.

```puppet
    include nsd::remote
```

### Zone configuration

You can use hiera-file or the template directory to store your
zone files that you want to have deployed to your NSD server.
The default is to pick them up from the modules template directory.

If you are using hiera, you may have the configuration like the
following example, additionally to the rest of your NSD configuration,
for one forward and one reverse zone:

```
    hiera
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

```
   puppet
     $nsd_config = hiera_hash('nsd_config')
     create_resources(nsd::zone, $nsd_config['zones'], { templatestorage => $nsd_config['templatestorage'] })
```

## Contribute

Please help me make this module awesome!  Send pull requests and file issues.
