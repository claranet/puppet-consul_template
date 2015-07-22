# == Class consul_template::config
#
# This class is called from consul_template for service config.
#
class consul_template::config (
  $consul_host,
  $consul_port,
  $consul_token,
  $consul_retry,
  $purge = true,
) {

  concat::fragment { 'header':
    target  => 'consul-template/config.json',
    content => inline_template("consul = \"<%= @consul_host %>:<%= @consul_port %>\"\ntoken = \"<%= @consul_token %>\"\nretry = \"<%= @consul_retry %>\"\n\n"),
    order   => '00',
  }

  # Set the log level
  concat::fragment { 'log_level':
    target  => 'consul-template/config.json',
    content => inline_template("log_level = \"${::consul_template::log_level}\"\n"),
    order   => '01'
  }

  file { $consul_template::config_dir:
    ensure  => 'directory',
    purge   => $purge,
    recurse => $purge,
  } ->
  concat { 'consul-template/config.json':
    path   => "${consul_template::config_dir}/config.json",
    notify => Service['consul-template'],
  }

}
