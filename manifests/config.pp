# == Class consul_template::config
#
# This class is called from consul_template for service config.
#
class consul_template::config (
  $ensure       = 'present',

  $consul_host  = '127.0.0.1',
  $consul_port  = '8500',

  $token        = undef,
  $retry        = '5s',
  $wait         = undef,
  $max_stale    = '1s',

  $user         = 'consul-template',
  $config_dir   = '/etc/consul-template/config.d',
  $template_dir = '/etc/consul-template/template.d',
  $log_level    = 'warn',
) {

  $dir_ensure = $ensure ? {
    present => 'directory',
    default => 'absent',
  }

  user { $user:
    ensure => $ensure,
    gid    => $user,
  }

  group { $user:
    ensure => $ensure,
  }

  # don't allow just any user to exec
  file { '/usr/bin/consul-template':
    mode  => '0750',
    owner => 'root',
    group => $user,
  }

  file { $config_dir:
    ensure => $dir_ensure,
    mode   => '0755',
    owner  => 'root',
    group  => $user,
  }

  file { $template_dir:
    ensure => $dir_ensure,
    mode   => '0755',
    owner  => 'root',
    group  => $user,
  }

  file { "${config_dir}/consul-template.hcl":
    ensure  => $ensure,
    mode    => '0644',
    owner   => 'root',
    group   => $user,
    content => template('consul_template/etc/consul-template/config.d/consul-template.hcl.erb'),
  }

  if $ensure == 'present' {
    Group[$user]
      -> User[$user]
      -> File["${config_dir}/consul-template.hcl"]
  } else {
    File["${config_dir}/consul-template.hcl"]
      -> User[$user]
      -> Group[$user]
  }
}
