include apache

class { 'apache::vhost':
  port => 8080,
}
