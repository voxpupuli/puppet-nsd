# Class: nsd
#
# Installs and configures NSD, the authoritative DNS resolver from NLnet Labs
#
class nsd (
  $verbosity        = 0,
  $interface        = ['::0','0.0.0.0'],
  $port             = '53',
  $config_d         = $nsd::params::config_d,
  $config_file      = $nsd::params::config_file,
  $service_name     = $nsd::params::service_name,
  $package_name     = $nsd::params::package_name,
  $control_cmd      = $nsd::params::control_cmd,
  $setup_cmd        = $nsd::params::control_cmd,
  $zonedir          = $nsd::params::zonedir,
  $zonepurge        = false, # purge of unmanaged zone files
  $group            = $nsd::params::group,
  $owner            = $nsd::params::owner,
  $database         = $nsd::params::database,
) inherits nsd::params {

  validate_bool($zonepurge)

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
    status  => 'nsd-control status',
    require => [
      Concat[$config_file],
      Exec['nsd-control-setup'],
    ],
  }

  concat { $config_file:
    owner  => 'root',
    group  => $group,
    mode   => '0640',
    notify => [
      Exec['nsd-control reconfig'],
      Exec['nsd-control reload'],
    ],
  }

  concat::fragment { 'nsd-header':
    order   => '00',
    target  => $config_file,
    content => template('nsd/nsd.conf.erb'),
  }

  exec { 'nsd-control-setup':
    command => $setup_cmd,
    creates => "${config_d}/nsd_control.pem",
  }

  exec { 'nsd-control reload':
    command     => "$control_cmd reload",
    refreshonly => true,
    require     => Service[$service_name],
  }

  exec { 'nsd-control reconfig':
    command     => "$control_cmd reconfig",
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
