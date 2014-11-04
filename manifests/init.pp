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

  include ::apache::install
  include ::apache::config
  include ::apache::service

  Class['::apache::install'] ->
  Class['::apache::config'] ~>
  Class['::apache::service']
}
