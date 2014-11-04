define apache::vhost (
  $ensure         = 'present',
  $documentroot   = undef,
  $errorlog       = undef,
  $port           = 80,
  $servername     = $title,
) {

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
}
