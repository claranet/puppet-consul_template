# == Class consul_template::service
#
# Ensure the service is running
#
class consul_template::service(
  $ensure = 'present',
  $status = 'enabled',
) {

  require consul_template::package
  require consul_template::config

  if $ensure == 'present' {
    case $status {
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }

      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }

      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }

      'unmanaged': {
        $service_ensure = undef
        $service_enable = false
      }

      default: {
        fail("consul_template::service: status was an unexpected value: ${status}")
      }
    }

  } else {
    $service_ensure = 'stopped'
    $service_enable = false
  }

  # Upstart service
  file { '/etc/init/consul-template.conf':
    ensure  => $ensure,
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    content => template('consul_template/etc/init/consul-template.conf.erb'),
  }

  service { 'consul_template':
    ensure   => $service_ensure,
    enable   => $service_enable,
    provider => 'upstart',
  }

  Class['consul_template::package'] ~> Service['consul_template']
  Class['consul_template::config']  ~> Service['consul_template']

  if $ensure == 'present' {
    File['/etc/init/consul-template.conf'] ~> Service['consul_template']
  } else {
    Service['consul_template'] -> File['/etc/init/consul-template.conf']
  }
}
