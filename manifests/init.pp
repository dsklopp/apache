class apache (
  $listen     = 80,
  $servername = $::fqdn,
  $version    = 'installed',
) {
  case $::osfamily {
    'RedHat': {
      $config_file  = '/etc/httpd/conf/httpd.conf'
      $package      = 'httpd'
      $service      = 'httpd'
    }
    'Debian': {
      $config_file  = '/etc/apache2/apache2.conf'
      $package      = 'apache2'
      $service      = 'apache2'
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
    content => template("apache/apache.conf.${::osfamily}.erb"),
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
