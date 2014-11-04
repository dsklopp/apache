class apache::config (
  $config_file  = $::apache::config_file,
  $documentroot = $::apache::documentroot,
  $errorlog     = $::apache::errorlog,
  $group        = $::apache::group,
  $listen       = $::apache::listen,
  $servername   = $::apache::servername,
  $user         = $::apache::user,
) {
  file { $config_file:
    ensure  => 'file',
    content => template('apache/apache.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }
}
