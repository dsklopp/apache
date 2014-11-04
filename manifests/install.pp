class apache::install (
  $package = $::apache::package,
  $version = $::apache::version,
) {
  package { $package:
    ensure => $version,
  }
}
