# Class: nsd::remote
#
# Configure remote control of the nsd daemon process
#
class nsd::remote (
  Boolean $enable                                  = true,
  Array[String] $interface                         = ['::1', '127.0.0.1'],
  Integer $port                                    = 8952,
  Optiona[Stdlib::Absolutepath] $server_key_file   = undef,
  Optiona[Stdlib::Absolutepath] $server_cert_file  = undef,
  Optiona[Stdlib::Absolutepath] $control_key_file  = undef,
  Optiona[Stdlib::Absolutepath] $control_cert_file = undef,
) {

  include ::nsd

  $config_file = $nsd::config_file

  concat::fragment { 'nsd-remote':
    order   => '10',
    target  => $config_file,
    content => template('nsd/remote.erb'),
  }
}
