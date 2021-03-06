class hdo::webapp {
  include hdo::common
  include hdo::params

  $requirements = [
    'htop',
    'dpkg',
    'libxml2',
    'libxml2-dev',
    'libxslt1-dev',
    'imagemagick',
    'libpq-dev',
  ]

  package { $requirements:
    ensure => 'installed'
  }

  file { [ $hdo::params::deploy_root, $hdo::params::files_root ]:
    ensure  => 'directory',
    mode    => '0775',
    owner   => 'hdo'
  }

  file { '/etc/profile.d/hdo-webapp.sh':
    ensure  => file,
    mode    => '0775',
    content => template('hdo/profile.sh')
  }

  file { '/home/hdo/.hdo-database-pg.yml':
    owner   => 'hdo',
    mode    => '0600',
    content => template('hdo/database.yml'),
    require => File['/home/hdo']
  }

  logrotate::rule { 'hdo-site':
    path         => "${hdo::params::deploy_root}/shared/log/*.log",
    compress     => true,
    copytruncate => true,
    dateext      => true,
    ifempty      => false,
    missingok    => true
  }
}

