# Define: nsd::zone
#
define nsd::zone (
  String $template,
  Hash $vars       = {},
  $templatestorage = 'puppet',
) {
  include nsd

  $config_file = $nsd::config_file
  $owner       = $nsd::owner
  $zonedir     = $nsd::zonedir
  $zonefile    = "${name}.zone"

  concat::fragment { "nsd-zone-${name}":
    order   => '05',
    target  => $config_file,
    content => template('nsd/zone.erb'),
  }

  case $templatestorage {
    'puppet': {
      file { "${zonedir}/${zonefile}":
        owner   => $owner,
        group   => '0',
        mode    => '0640',
        content => template($template),
        notify  => Exec["nsd-control reload ${name}"],
      }
    }
    'hiera': {
      file { "${zonedir}/${zonefile}":
        owner   => $owner,
        group   => '0',
        mode    => '0640',
        content => hiera($template),
        notify  => Exec["nsd-control reload ${name}"],
      }
    }
    default: { fail('templatestorage must be either \'puppet\' or \'hiera\'') }
  }

  exec { "nsd-control reload ${name}":
    command     => "${nsd::control_cmd} reload ${name}",
    refreshonly => true,
    require     => [Concat[$config_file], Service[$nsd::service_name],],
  }
}
