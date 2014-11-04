class apache::service (
  $service = $::apache::service,
) {
  service { $service:
    ensure => 'running',
    enable => true,
  }
}
