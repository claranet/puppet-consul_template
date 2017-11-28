# == Class consul_template::config
#
# This class is called from consul_template for service config.
#
class consul_template::config (
  $config_hash = {},
  $purge       = true,
) {

  # Using our parent module's pretty_config & pretty_config_indent just because
  $content_full = consul_sorted_json($config_hash, $consul::pretty_config, $consul::pretty_config_indent)
  # remove the closing } and it's surrounding newlines
  $content = regsubst($content_full, "\n}\n$", '')

  $concat_name = 'consul-template/config.json'

  concat::fragment { 'consul-service-pre':
    target  => $concat_name,
    # add the opening template array so that we can insert watch fragments
    content => "${content},\n    \"template\": [\n",
    order   => '1',
  }

  # Realizes concat::fragments from consul_template::watches that make up 1 or
  # more template configs.
  Concat::Fragment <| target == $concat_name |>

  concat::fragment { 'consul-service-post':
    target  => $concat_name,
    # close off the template array and the whole object
    content => "    ],\n}",
    order   => '99',
  }

  if $::consul_template::consul_ssl_enabled {
    concat::fragment { 'consul-ssl-base':
      target  => 'consul-template/config.json',
      content => inline_template("ssl {\n  enabled = true\n  cert = \"${::consul_template::consul_ssl_cert}\"\n  ca_cert = \"${::consul_template::consul_ssl_ca_cert}\"\n  verify = ${::consul_template::consul_ssl_verify}\n}\n\n"),
      order   => '08',
    }
  }

  file { [$consul_template::config_dir, "${consul_template::config_dir}/config"]:
    ensure  => 'directory',
    purge   => $purge,
    recurse => $purge,
    owner   => $consul_template::user,
    group   => $consul_template::group,
    mode    => '0755',
  }
  -> concat { $concat_name:
    path   => "${consul_template::config_dir}/config/config.json",
    owner  => $consul_template::user,
    group  => $consul_template::group,
    mode   => $consul_template::config_mode,
    notify => Service['consul-template'],
  }

}
