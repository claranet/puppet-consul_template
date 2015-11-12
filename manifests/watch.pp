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
  $destination = undef,
  $command     = undef
) {
  include consul_template

  if $content != undef {
    $source = "${consul_template::template_dir}/${id}.ctmpl"
    file { $source:
      ensure  => $ensure,
      content => $content,
    }
  } elsif $source == undef {
    fail("Must pass either source or content to consul_template::watch")
  }

  if $destination == undef {
    $destination = $title
  }

  file { "${consul_template::source_dir}/${id}.hcl":
    mode => '0644',
    owner => 'root',
    group => 'root',
    content => template('consul_template/etc/consul-template/config.d/watch.hcl.erb'),
    notify  => Service['consul_template'],
  }
}
