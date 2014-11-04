package { 'httpd':
  ensure => 'installed',
}

file { '/etc/httpd/conf/httpd.conf':
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0444',
  source => '/home/student/apache/examples/httpd.conf',
}

service { 'httpd':
  ensure => 'running',
  enable => true,
}
