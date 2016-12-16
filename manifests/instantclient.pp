#
# https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-basic.rpm
# https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-devel.rpm
# https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-sqlplus.rpm
#
class oracleclient::instantclient (
                                    $basic_url      = undef,
                                    $devel_url      = undef,
                                    $sqlpus_url     = undef,
                                    $ver            = '11.2',
                                    $package_ensure = 'installed',
                                    $srcdir         = '/usr/local/src',
                                  ) inherits oracleclient::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($basic_url==undef or $devel_url==undef or $sqlpus_url==undef)
  {
    fail('URLs missing, basic_url, devel_url and sqlpus_url are required')
  }

  exec { 'which wget eyp-oracleclient':
    command => 'which wget',
    unless  => 'which wget',
  }

  exec { "mkdir p oracleclient instantclient ${srcdir}":
    command => "mkdir -p ${srcdir}",
    creates => $srcdir,
  }

  exec { "wget instantclient sqlplus ${srcdir}":
    command => "wget ${sqlpus_url} -O ${srcdir}/oracle-instantclient11.2-sqlplus.rpm",
    creates => "${srcdir}/oracle-instantclient11.2-sqlplus.rpm",
    requires => Exec[ [ 'which wget eyp-oracleclient', "mkdir p oracleclient instantclient ${srcdir}" ] ],
  }

  exec { "wget instantclient devel ${srcdir}":
    command => "wget ${devel_url} -O ${srcdir}/oracle-instantclient11.2-devel.rpm",
    creates => "${srcdir}/oracle-instantclient11.2-devel.rpm",
    requires => Exec[ [ 'which wget eyp-oracleclient', "mkdir p oracleclient instantclient ${srcdir}" ] ],
  }

  exec { "wget instantclient basic ${srcdir}":
    command => "wget ${basic_url} -O ${srcdir}/oracle-instantclient11.2-basic.rpm",
    creates => "${srcdir}/oracle-instantclient11.2-basic.rpm",
    requires => Exec[ [ 'which wget eyp-oracleclient', "mkdir p oracleclient instantclient ${srcdir}" ] ],
  }


  # oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386
  # package { "oracle-instantclient11.2-sqlplus":
  #   ensure => $package_ensure,
  # }
  # oracle-instantclient11.2-basic-11.2.0.4.0-1.i386
  # oracle-instantclient11.2-devel-11.2.0.4.0-1.i386
}
