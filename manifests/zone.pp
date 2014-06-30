#
define nsd::zone (
  $template,
) {

  include nsd::params

  $config_file = $nsd::params::config_file
  $owner       = $nsd::params::owner
  $zonedir     = $nsd::params::zonedir
  $zonefile    = "${name}.zone"

  concat::fragment { "nsd-zone-${name}":
    order   => '05',
    target  => $config_file,
    content => template('nsd/zone.erb'),
  }

  file { "${zonedir}/${zonefile}":
    owner   => $owner,
    group   => '0',
    mode    => '0640',
    content => template($template),
    notify  => Exec["nsd-control reload ${name}"],
  }

  exec { "nsd-control reload ${name}":
    command     => "nsd-control reload ${name}",
    refreshonly => true,
  }
}
