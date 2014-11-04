class apache (
  $listen     = 80,
  $servername = $::fqdn,
  $version    = 'installed',
) {
  case $::osfamily {
    'RedHat': {
      $config_file  = '/etc/httpd/conf/httpd.conf'
      $errorlog     = '/var/log/httpd/error.log'
      $package      = 'httpd'
      $service      = 'httpd'
      $user         = 'apache'
      $group        = 'apache'
      $documentroot = '/var/www/html'
    }
    'Debian': {
      $config_file  = '/etc/apache2/apache2.conf'
      $errorlog     = '/var/log/apache2/error.log'
      $package      = 'apache2'
      $service      = 'apache2'
      $user         = 'www-data'
      $group        = 'www-data'
      $documentroot = '/var/www'
    }
    default: {
      fail("${::osfamily} isn't supported by ${module_name}")
    }
  }

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
