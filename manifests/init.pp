# Class: nsd
#
# Installs and configures NSD, the authoritative DNS resolver from NLnet Labs
#
class nsd (
  $verbosity        = 0,
  $interface        = ['::0','0.0.0.0'],
  $port             = '53',
  $config_file      = $nsd::params::config_file,
  $service_name     = $nsd::params::service_name,
  $package_name     = $nsd::params::package_name,
  $package_provider = $nsd::params::package_provider,
  $control_cmd      = $nsd::params::control_cmd,
  $zonedir          = $nsd::params::zonedir,
  $group            = $nsd::params::group,
  $owner            = $nsd::params::owner,
  $database         = $nsd::params::database,
) inherits nsd::params {

  if ! $package_name == '' {
    package { $package_name:
      ensure   => installed,
      provider => $package_provider,
      before   => [
        Concat[$config_file],
        Service[$service_name],
      ]
    }
  }

  service { $service_name:
    ensure => running,
    name   => $service_name,
    enable => true,
    status => 'nsd-control status',
  }

  concat { $config_file:
    owner  => 'root',
    group  => $group,
    mode   => '0640',
    notify => [
      Exec['nsd-control reconfig'],
      Exec['nsd-control reload'],
    ]
  }

  concat::fragment { 'nsd-header':
    order   => '00',
    target  => $config_file,
    content => template('nsd/nsd.conf.erb'),
  }

  exec { 'nsd-control reload':
    command     => 'nsd-control reload',
    refreshonly => true,
    #notify      => Exec['nsd-control reconfig'],
  }

  exec { 'nsd-control reconfig':
    command     => 'nsd-control reconfig',
    refreshonly => true,
  }
}
