class apache::vhost (
  $ensure         = 'present',
  $documentroot   = undef,
  $errorlog       = undef,
  $port           = 80,
  $servername     = $fqdn,
) {
  file { "/etc/httpd/conf.d/${servername}.conf":
    ensure  => $ensure,
    content => template('apache/vhost.conf.erb'),
    group   => 'root',
    owner   => 'root',
    mode    => '0444',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
}