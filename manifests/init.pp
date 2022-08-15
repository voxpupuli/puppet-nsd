# Class: nsd
#
# Installs and configures NSD, the authoritative DNS resolver from NLnet Labs
#
class nsd (
  String $config_d,
  String $config_file,
  String $service_name,
  Variant[String,Undef] $package_name,
  String $control_cmd,
  String $control_setup_cmd,
  String $zonedir,
  Boolean $zonepurge, # purge of unmanaged zone files
  String $group,
  String $owner,
  String $database,
  Integer $verbosity                    = 0,
  Integer $port                         = 53,
  Array[Stdlib::Ip::Address] $interface = ['::0','0.0.0.0'],
  Optional[String] $logfile             = undef,
) {
  if $package_name {
    package { $package_name:
      ensure => installed,
      before => [
        Concat[$config_file],
        Service[$service_name],
      ],
    }
  }

  service { $service_name:
    ensure  => running,
    name    => $service_name,
    enable  => true,
    require => [
      Concat[$config_file],
    ],
  }

  concat { $config_file:
    owner  => 'root',
    group  => $group,
    mode   => '0640',
    notify => Service[$service_name],
  }

  concat::fragment { 'nsd-header':
    order   => '00',
    target  => $config_file,
    content => template('nsd/nsd.conf.erb'),
  }

  exec { 'nsd-control-setup':
    command => $control_setup_cmd,
    creates => "${config_d}/nsd_control.pem",
  }

  exec { 'nsd-control reload':
    command     => "${control_cmd} reload",
    refreshonly => true,
    require     => Service[$service_name],
  }

  exec { 'nsd-control reconfig':
    command     => "${control_cmd} reconfig",
    refreshonly => true,
    require     => Service[$service_name],
  }

  file { $zonedir:
    ensure  => directory,
    owner   => 'root',
    group   => $group,
    mode    => '0750',
    purge   => $zonepurge,
    recurse => true,
  }
}
