class apache {
  $listen     = 80
  $servername = $::fqdn
  package { 'httpd':
    ensure => 'installed',
    before => File['/etc/httpd/conf/httpd.conf'],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('apache/httpd.conf.erb'),
    notify  => Service['httpd'],
  }

  service { 'httpd':
    ensure => 'running',
    enable => true,
  }
}

