class apache {
  package { 'httpd':
    ensure => 'installed',
    before => File['/etc/httpd/conf/httpd.conf'],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    source => 'puppet:///modules/apache/httpd.conf',
    notify => Service['httpd'],
  }

  service { 'httpd':
    ensure => 'running',
    enable => true,
  }
}
