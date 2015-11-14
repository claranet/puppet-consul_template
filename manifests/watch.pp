# == Definition consul_template::watch
#
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file

# consul_template::watch { '/etc/elasticsearch/elasticsearch.yml':
#   source => '/etc/consul-template/template.d/elasticsearch.yml.ctmpl',
# }

# consul_template::watch { 'es_dynamic':
#   source => 'dynamic.yml.ctmpl',
#   destination => '/etc/init.d/elasticsearch/dynamic.yml',
#   command => 'update_dynamic_vars'
# }

# consul_template::watch { '/etc/init.d/elasticsearch/elasticsearch.yml':
#   content => template('elasticsearch/elasticsearch.yml.ctmpl'),
# }
#
# TODO add a consul_template::template definition so the template dir
# is not exposed
define consul_template::watch (
  $ensure      = present,
  $id          = $title,
  $source      = undef,
  $content     = undef,
  $destination = $title,
  $command     = undef,
  $perms       = undef,
) {
  require consul_template

  $sanitized_id = regsubst($id, '/', '_', 'G')

  if $content != undef {
    $template_source = "${consul_template::config::template_dir}/${sanitized_id}.ctmpl"
    file { $generated_source:
      ensure  => $ensure,
      mode    => '0644',
      owner   => 'root',
      group   => $consul_template::config::user,
      content => $content,
    }
  } elsif $source == undef {
    fail("consul_template::watch: Must pass either source or content")
  } else {
    $template_source = $source
  }

  # Fail if destination isn't an absolute path
  if $destination !~ /^\// {
    fail("consul_template::watch: Destination must be an absolute path (was \"${destination}\")")
  }

  file { "${consul_template::config::config_dir}/${sanitized_id}.hcl":
    ensure  => $ensure,
    mode    => '0644',
    owner   => 'root',
    group   => $consul_template::config::user,
    content => template('consul_template/etc/consul-template/config.d/watch.hcl.erb'),
    notify  => Service['consul-template'],
  }
}
