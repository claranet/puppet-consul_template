# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $config_hash   = {},
  $template      = undef,
  $template_vars = {},
) {
  include consul_template

  if $template == undef and $config_hash['source'] == undef {
    err ('Specify either template parameter or config_hash["source"] for consul_template::watch')
  }

  if $template != undef and $config_hash['source'] != undef {
    err ('Specify either template parameter or config_hash["source"] for consul_template::watch - but not both')
  }

  if $template == undef {
    # source is specified in config_hash
    $config_source = {}
    $frag_name = $config_hash['source']
  } else {
    # source is specified as a template
    $source = "${consul_template::config_dir}/${name}.ctmpl"
    $config_source = {
      source => $source,
    }
    file { $source:
      ensure  => present,
      owner   => $consul_template::user,
      group   => $consul_template::group,
      mode    => $consul_template::config_mode,
      content => template($template),
      before  => Concat::Fragment["${name}.ctmpl"],
      notify  => Service['consul-template'],
    }
    $frag_name = $source
  }

  $config_hash_real = deep_merge($config_hash, $config_source)
  $content = consul_sorted_json($config_hash_real, $consul::pretty_config, $consul::pretty_config_indent)
  concat::fragment { $frag_name:
    target  => 'consul-template/config.json',
    content => "template ${content}\n\n",
    order   => '10',
    notify  => Service['consul-template']
  }
}
