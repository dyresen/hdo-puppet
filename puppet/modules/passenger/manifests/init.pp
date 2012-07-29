class passenger {

  $passenger_ruby          = "/usr/bin/ruby1.9.1"
  $passenger_root          = "/usr/lib/phusion-passenger"
  $passenger_min_instances = 3
  $passenger_max_pool_size = 10
  $passenger_max_instances_per_app = 10 # only running one app
  $passenger_pool_idle_time = 300

  include apache
	include ruby

  ruby::gem { "passenger": }

  # We don't use libapache2-mod-passenger I suspect because it's too old?
	exec { "passenger-apache":
    path    => ["/bin", "/usr/bin", "/var/lib/gems/1.9.1/gems/passenger-3.0.13/bin"],
    command => "passenger-install-apache2-module --auto && cd /etc/apache2/mods-enabled",
    creates => "/etc/apache2/mods-available/passenger.conf",
    require => Ruby::Gem["passenger"],
  }

  file { "/etc/apache2/conf.d/passenger.conf":
    owner   => root,
    mode    => 644,
    content => template("passenger/passenger.conf.erb"),
    require => Ruby::Gem['passenger'],
    notify  => Service['apache2']
  }

}