# == Class consul_template::service
#
# This class is meant to be called from consul_template.
# It ensure the service is running.
#
class consul_template::service {

  $service_provider = $::consul_template::init_style ? {
    'sysv'      => 'redhat',
    'unmanaged' => undef,
    default     => $::consul_template::init_style,
  }

  service { 'consul-template':
    ensure   => $consul_template::service_ensure,
    enable   => $consul_template::service_enable,
    provider => $service_provider,
    name     => 'consul-template',
  }

}
