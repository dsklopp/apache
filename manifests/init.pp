class apache (
  $config_file  = $::apache::params::config_file,
  $documentroot = $::apache::params::documentroot,
  $errorlog     = $::apache::params::errorlog,
  $group        = $::apache::params::group,
  $listen       = 80,
  $package      = $::apache::params::package,
  $service      = $::apache::params::service,
  $servername   = $::fqdn,
  $user         = $::apache::params::user,
  $version      = 'installed',
) inherits ::apache::params {
  package { $package:
    ensure => $version,
    before => File[$config_file],
  }

  file { $config_file:
    ensure  => 'file',
    content => template("apache/apache.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Service[$service],
  }

  service { $service:
    ensure => 'running',
    enable => true,
  }
}
