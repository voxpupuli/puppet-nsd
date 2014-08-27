# Class: nsd::remote
#
# Configure remote control of the nsd daemon process
#
class nsd::remote (
  $enable            = true,
  $interface         = ['::1', '127.0.0.1'],
  $port              = 8952,
  $server_key_file   = undef,
  $server_cert_file  = undef,
  $control_key_file  = undef,
  $control_cert_file = undef
) {

  include nsd::params

  $config_file = $nsd::params::config_file

  concat::fragment { 'nsd-remote':
    order   => 10,
    target  => $config_file,
    content => template('nsd/remote.erb'),
  }
}
