define apache::vhost (
  $ensure         = 'present',
  $documentroot   = undef,
  $errorlog       = undef,
  $port           = 80,
  $servername     = $title,
) {

  # ensure must be present or absent
  unless member(['present', 'absent'], $ensure) {
    fail("${module_name} ${title}: ensure ${servername} must be 'present' or 'absent'")
  }

  # If defined, documentroot must be an absolute path
  if $documentroot {
    validate_absolute_path($documentroot)
  }

  # Port must be defined and numeric`
  unless is_numeric($port) {
    fail("${module_name} ${title}: port ${port} must be an integer")
  }

  # Port must be between 0 and 65534
  unless $port >= 0 and $port <= 65534 {
    fail("${module_name} ${title}: port ${port} is not a port between 0 and 65534")
  }

  # If defined, errorlog must be an absolute path
  if $errorlog {
    validate_absolute_path($errorlog)
  }

  # servername must match apache's specifications
  # http://httpd.apache.org/docs/2.2/mod/core.html#servername
  validate_re($servername, '^([a-z]+:\/\/)?[\w\-\.]+(:[\d]+)?$')

  $vhost_dir = $::osfamily ? {
    'RedHat' => '/etc/httpd/conf.d',
    'Debian' => '/etc/apache2/sites-available',
    default  => '/etc/httpd/conf.d',
  }

  $link_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'link',
  }

  file { "${vhost_dir}/${title}.conf":
    ensure  => $ensure,
    content => template('apache/vhost.conf.erb'),
    group   => 'root',
    owner   => 'root',
    mode    => '0444',
  }

  if $::osfamily == 'Debian' {
    file { "/etc/apache2/sites-enabled/${title}.conf":
      ensure => $link_ensure,
      target => "../sites-available/${title}.conf",
    }
  }

  Class['::apache::install'] ->
  Apache::Vhost[$title] ~>
  Class['::apache::service']
}
