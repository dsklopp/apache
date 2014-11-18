include 'apache'


apache::vhost { 'test1.localdomain':
  port => 8080,
}

apache::vhost { 'test2.localdomain':
  port => 8081,
}
