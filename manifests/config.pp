# == Class consul_template::config
#
# This class is called from consul_template for service config.
#
class consul_template::config (
  $config_hash = {},
  $purge       = true,
) {
  # Using our parent module's pretty_config & pretty_config_indent just because
  $content = consul_sorted_json($config_hash, $consul::pretty_config, $consul::pretty_config_indent)[0,-1]

  $config_file = "${consul_template::config_dir}/config/config.json"
  concat::fragment { 'consul-service-pre':
    target  => $config_file,
    content => "${content},\n    \"template\": [\n",
    order   => '1',
  }

  Concat::Fragment <| target == 'consul-template/config.json' |>

  concat::fragment { 'consul-service-post':
    target  => $config_file,
    content => "    ],\n}",
    order   => '99',
  }

  file { [$consul_template::config_dir, "${consul_template::config_dir}/config"]:
    ensure  => 'directory',
    purge   => $purge,
    recurse => $purge,
    owner   => $consul_template::user,
    group   => $consul_template::group,
    mode    => '0755',
  } ->
  concat { 'consul-template/config.json':
    path   => $config_file,
    owner  => $consul_template::user,
    group  => $consul_template::group,
    mode   => $consul_template::config_mode,
    notify => Service['consul-template'],
  }

}
