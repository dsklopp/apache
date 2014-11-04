class apache (
  $listen     = 80,
  $servername = $::fqdn,
  $version    = 'installed',
) {
  package { 'httpd':
    ensure => $version,
    before => File['/etc/httpd/conf/httpd.conf'],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => 'file',
    content => template('apache/httpd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Service['httpd'],
  }

  service { 'httpd':
    ensure => 'running',
    enable => true,
  }
}
