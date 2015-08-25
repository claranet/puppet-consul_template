# == Class: consul_template
#
# Installs, configures, and manages consul-template
#
class consul_template (
  $ensure  = 'present',
  $version = 'present',
  $status  = 'enabled',
) {
  validate_value($ensure, 'present', 'absent')

  class { 'consul_template::package':
    ensure  => $ensure,
    version => $version,
  }

  if $ensure == 'present' {
    include consul_template::config
    include consul_template::service
  } else {
    class { ['consul_template::config', 'consul_template::service']:
      ensure => absent,
    }
  }
}
