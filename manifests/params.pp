class apache::params {
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
}
