# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $command,
  $destination,
  $content       = undef,
  $source        = undef,
  $template      = undef,
  $template_vars = {},
  $perms = '0644',
) {
  include ::consul_template

  if $content == undef and $source == undef and $template == undef {
    err('Specify either content, source or template parameter for consul_template::watch')
  }

  if count([$content, $source, $template]) > 1 {
    err('Specify either content, source or template parameter for consul_template::watch, but only a single parameter should be specified')
  }

  if $source != undef {
    $source_name = $source
    $frag_name   = $source
  } else {
    $source_name = "${consul_template::config_dir}/${name}.ctmpl"
    $frag_name   = "${name}.ctmpl"
  }

  if $content != undef or $template != undef {
    if ($template != undef) {
      $config_content = template($template)
    } else {
      $config_content = $content
    }

    file { $source_name:
      ensure  => 'file',
      owner   => $consul_template::user,
      group   => $consul_template::group,
      mode    => $consul_template::config_mode,
      content => $config_content,
      before  => Concat::Fragment["${name}.ctmpl"],
      notify  => Service['consul-template'],
    }
  }

  concat::fragment { $frag_name:
    target  => 'consul-template/config.json',
    content => "template {\n  source = \"${source_name}\"\n  destination = \"${destination}\"\n  command = \"${command}\"\n  perms = ${perms}\n}\n\n",
    order   => '10',
    notify  => Service['consul-template']
  }
}
