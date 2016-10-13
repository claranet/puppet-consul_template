# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $destination,
  $backup          = undef,
  $contents        = undef,
  $command         = undef,
  $command_timeout = undef,
  $left_delimiter  = undef,
  $right_delimiter = undef,
  $perms           = undef,
  $source          = undef,
  $template        = undef,
  $template_vars   = {},
  $wait            = undef,
) {
  if !defined(Class['consul_template']) {
    fail("To use 'consul_template::watch', you must declare class 'consul_template' first")
  }

  if $backup != undef { validate_bool($backup) }
  validate_hash($template_vars)

  if !$template and !$source {
    fail('Specify either template or source parameter for consul_template::watch')
  }

  if $template and $source {
    fail('Specify either template or source parameter for consul_template::watch - but not both')
  }

  if $source {
    $real_source = $source
  } else {
    $real_source = "${::consul_template::config_dir}/${name}.ctmpl"
    file { $real_source:
      ensure  => file,
      owner   => $::consul_template::user,
      group   => $::consul_template::group,
      mode    => $::consul_template::config_mode,
      content => template($template),
      notify  => Service['consul-template'],
    }
  }

  concat::fragment { "consul-template/config.json+90-template-${name}":
    target  => 'consul-template/config.json',
    order   => '90',
    content => template('consul_template/watch.erb'),
    notify  => Service['consul-template']
  }
}
