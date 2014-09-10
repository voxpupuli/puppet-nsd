#
define nsd::zone (
  $template,
  $templatestorage = 'puppet',
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
    default: { fail("templatestorage must be either 'puppet' or 'hiera'") }
  }

  exec { "nsd-control reload ${name}":
    command     => "nsd-control reload ${name}",
    refreshonly => true,
    require     => Concat[$config_file],
  }
}
