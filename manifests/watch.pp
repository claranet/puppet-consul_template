# == Class consul_template::watch
#
# This class is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
class consul_template::watch (
  $template,
  $destination,
  $command,
) {
  file { "${consul_template::config_dir}/${name}.ctmpl":
    ensure  => present,
    content => $template,
  } ->

  concat::fragment { "${name}.ctmpl":
    target  => 'consul-template/config.json',
    content => "template {\n  source = \"${consul_template::config_dir}/${name}.ctmpl\"\n  destination = \"${destination}\"\n  command = \"${command}\"\n}\n\n",
    order   => '10',
  }
}
