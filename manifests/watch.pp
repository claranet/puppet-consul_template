# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $config_hash   = {},

  # Deprecated params
  $command       = undef,
  $destination   = undef,
  $source        = undef,

  $template      = undef,
  $template_vars = {},
) {
  include consul_template

  if $command != undef {
    $config_command = { command => $command }
  } else {
    $config_command = {}
  }

  if $destination != undef {
    $config_destination = { destination => $destination }
  } else {
    $config_destination = {}
  }

  if $source != undef {
    $config_source = { source => $source }
    $frag_name   = $config_hash_real['source']
  } else {
    $config_source = { source => "${consul_template::config_dir}/${name}.ctmpl" }
    $frag_name   = "${name}.ctmpl"
  }

  validate_hash($config_hash)
  $config_hash_real = deep_merge($config_hash, $config_command, $config_destination, $config_source)
  validate_hash($config_hash_real)

  if $config_hash_real['template'] == undef and $config_hash_real['source'] == undef {
    err ('Specify either template or source parameter for consul_template::watch')
  }

  if $config_hash_real['template'] != undef and $config_hash_real['source'] != undef {
    err ('Specify either template or source parameter for consul_template::watch - but not both')
  }

  if $template != undef {
    file { "${consul_template::config_dir}/${name}.ctmpl":
      ensure  => present,
      owner   => $consul_template::user,
      group   => $consul_template::group,
      mode    => $consul_template::config_mode,
      content => template($template),
      before  => Concat::Fragment["${name}.ctmpl"],
      notify  => Service['consul-template'],
    }
  }

  concat::fragment { $frag_name:
    target  => 'consul-template/config.json',
    content => consul_sorted_json({ template => $config_hash_real }, $consul::pretty_config, $consul::pretty_config_indent),
    order   => '10',
    notify  => Service['consul-template']
  }
}
