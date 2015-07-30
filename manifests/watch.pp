# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $template = undef,
  $template_vars = {},
  $destination,
  $command,
) {
  include consul_template

  if $template != undef {
    file { "${consul_template::config_dir}/${name}.ctmpl":
      ensure  => present,
      content => template($template),
      before  => Concat::Fragment["${name}.ctmpl"],
    }
  }
  concat::fragment { "${name}.ctmpl":
    target  => 'consul-template/config.json',
    content => "template {\n  source = \"${consul_template::config_dir}/${name}.ctmpl\"\n  destination = \"${destination}\"\n  command = \"${command}\"\n}\n\n",
    order   => '10',
    notify  => Service['consul-template']
  }
}
