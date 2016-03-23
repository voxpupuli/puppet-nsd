# Class: nsd::params
#
# Set some params for the nsd module
#
class nsd::params {

  case $::operatingsystem {
    'OpenBSD': {
      $config_d      = '/var/nsd/etc'
      $config_file   = '/var/nsd/etc/nsd.conf'
      $zonedir       = '/var/nsd/zones'
      $service_name  = 'nsd'
      $package_name  = undef
      $owner         = '_nsd'
      $group         = '_nsd'
      $control_cmd   = 'nsd-control'
      $database      = '/var/nsd/db/nsd.db'
    }
    'FreeBSD': {
      $config_d     = '/usr/local/etc/nsd'
      $config_file  = '/usr/local/etc/nsd/nsd.conf'
      $zonedir      = '/usr/local/etc/nsd'
      $package_name = 'nsd'
      $service_name = 'nsd'
      $owner        = 'nsd'
      $group        = 'nsd'
      $control_cmd  = 'nsd-control'
      $database     = '/var/db/nsd/nsd.db'
    }
    default: {
      fail('nsd not supported on this platform, please help add support!')
    }
  }
}
