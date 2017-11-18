# == Definition consul_template::watch
#
# This definition is called from consul_template
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file
define consul_template::watch (
  $config_hash     = {},
  $config_defaults = {},
  $template        = undef,
  $template_vars   = {},
  $perms = '0644',
) {
  include ::consul_template

  $config_hash_real = deep_merge($config_defaults, $config_hash)
  if $template == undef and $config_hash_real['source'] == undef {
    err ('Specify either template parameter or config_hash["source"] for consul_template::watch')
  }

  if $template != undef and $config_hash_real['source'] != undef {
    err ('Specify either template parameter or config_hash["source"] for consul_template::watch - but not both')
  }

  if $template == undef {
    # source is specified in config_hash
    $config_source = {}
    $frag_name = $config_hash_real['source']
    $fragment_requires = undef
  } else {
    # source is specified as a template
    $source = "${consul_template::config_dir}/${name}.ctmpl"
    $config_source = {
      source => $source,
    }

    file { $source:
      ensure  => 'file',
      owner   => $consul_template::user,
      group   => $consul_template::group,
      mode    => $consul_template::config_mode,
      content => template($template),
      notify  => Service['consul-template'],
    }

    $frag_name = $source
    $fragment_requires = File[$source]
  }

  $config_hash_all = deep_merge($config_hash_real, $config_source)
  $content_full = consul_sorted_json($config_hash_all, $consul::pretty_config, $consul::pretty_config_indent)
  $content = regsubst(regsubst($content_full, "}\n$", '}'), "\n", "\n    ", 'G')

  @concat::fragment { $frag_name:
    target  => 'consul-template/config.json',
    # NOTE: this will result in all watches having , after them in the JSON
    # array. That won't pass strict JSON parsing, but luckily HCL is fine with it.
    content => "    $content,\n",
    order   => '50',
    notify  => Service['consul-template'],
    require => $fragment_requires,
  }
}
