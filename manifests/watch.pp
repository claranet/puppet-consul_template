# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $template = undef,
  $template_vars = {},
  $source = undef,
  $destination,
  $command,
) {
  include consul_template

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
    $frag_name   = "${name}.ctmpl"
    $source_name = "${consul_template::config_dir}/${name}.ctmpl"
  }
  if $source -= undef {
    $frag_name   = $name
    $source_name = $name
  } else {  
    $frag_name   = $source
    $source_name = $source
  }
  concat::fragment { "${frag_name}":
    target  => 'consul-template/config.json',
    content => "template {\n  source = \"${source_name}\"\n  destination = \"${destination}\"\n  command = \"${command}\"\n}\n\n",
    order   => '10',
    notify  => Service['consul-template']
  }
}
