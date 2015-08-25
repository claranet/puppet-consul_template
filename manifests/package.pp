# == Class consul_template::package
#
# Install the consul-template package
#
class consul_template::package(
  $ensure  = 'present',
  $version = 'present'
) {

  $_ensure = $ensure ? {
    'present' => $version,
    default   => $ensure,
  }

  package { 'consul-template':
    ensure => $_ensure,
  }

  apt::pin { 'consul-template':
    packages => 'consul-template',
    version  => $version,
    priority => '2000',
  }
}
