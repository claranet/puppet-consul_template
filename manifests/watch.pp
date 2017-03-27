# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $command,
  $destination,
  $source        = undef,
  $template      = undef,
  $template_vars = {},
) {
  include consul_template

  if $template == undef and $source == undef {
    err ('Specify either template or source parameter for consul_template::watch')
  }

  if $template != undef and $source != undef {
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

  if $source != undef {
    $source_name = $source
    $frag_name   = $source
  } else {
    $source_name = "${consul_template::config_dir}/${name}.ctmpl"
    $frag_name   = "${name}.ctmpl"
  }

  concat::fragment { $frag_name:
    target  => 'consul-template/config.json',
    content => "template {\n  source = \"${source_name}\"\n  destination = \"${destination}\"\n  command = \"${command}\"\n}\n\n",
    order   => '99',
    notify  => Service['consul-template']
  }
}
