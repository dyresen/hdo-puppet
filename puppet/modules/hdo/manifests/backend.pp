class hdo::backend {
  include ruby
  include hdo::common
  include hdo::params

  $requirements = [
      'htop',
      'dpkg',
      'build-essential',
      'git-core',
      'libxml2',
      'libxml2-dev',
      'libxslt1-dev',
      'libcurl4-openssl-dev',   # libcurl6?
      'imagemagick',
  ]

  package { $requirements:
    ensure => 'installed'
  }

  ruby::gem { 'bundler':
    name    => 'bundler',
    version => '>= 1.2.0'
  }

  file { [ $hdo::params::webapp_root, $hdo::params::deploy_root ]:
    ensure  => 'directory',
    mode    => '0775',
    owner   => 'hdo'
  }

  file { '/etc/profile.d/hdo-backend.sh':
    ensure  => file,
    mode    => '0775',
    content => template('hdo/profile.sh')
  }
}

