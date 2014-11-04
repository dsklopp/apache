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
  # config_file must be an absolute path
  validate_absolute_path($config_file)

  # document_root must be an absolute path
  validate_absolute_path($documentroot)

  # errorlog must be an absolute path
  validate_absolute_path($errorlog)

  # group must match debian's useradd filter
  validate_re($group, '^[_.A-Za-z0-9][-\@_.A-Za-z0-9]*\$?$')

  # listen must be defined and an integer
  unless is_numeric($listen) {
    fail("${module_name}: listen ${listen} must be an integer")
  }

  # listen must be a valid port number
  unless $listen >= 0 and $listen <= 65534 {
    fail("${module_name}: listen ${listen} must be a port between 0 and 65534")
  }

  # package must be one or more printable characters
  validate_re($package, '^[[:print:]]+$')

  # user must match debian's useradd filter
  validate_re($user, '^[_.A-Za-z0-9][-\@_.A-Za-z0-9]*\$?$')

  # service must only contain printable characters, and length > 1
  validate_re($service, '^[[:print:]]+$')

  # servername must match apache's specifications
  # http://httpd.apache.org/docs/2.2/mod/core.html#servername
  validate_re($servername, '^([a-z]+:\/\/)?[\w\-\.]+(:[\d]+)?$')

  include ::apache::install
  include ::apache::config
  include ::apache::service

  Class['::apache::install'] ->
  Class['::apache::config'] ~>
  Class['::apache::service']
}
