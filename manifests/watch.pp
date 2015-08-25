# == Definition consul_template::watch
#
# This is a single instance of a configuration file to watch
# for changes in Consul and update the local file

# consul_template::watch { '/etc/init.d/elasticsearch.d/cluster.yml':
#   source => '/etc/consul-template.d/cluster.yml.ctmpl',
# }

# consul_template::watch { 'es_dynamic':
#   source => '/etc/consul-template.d/dynamic.yml.ctmpl',
#   destination => '/etc/init.d/elasticsearch.d/dynamic.yml',
#   command => 'update_dynamic_vars'
# }

# consul_template::watch { '/etc/init.d/elasticsearch.d/cluster.yml':
#   content => template('elasticsearch/cluster.yml.ctmpl'),
# }
define consul_template::watch (
  $ensure  = present,
  $id      = $title,
  $source  = undef,
  $content = undef,
  $destination,
  $command = undef
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

  file { "${consul_template::source_dir}/${id}.hcl":
    mode => '0644',
    owner => 'root',
    group => 'root',
    content => template('consul_template/etc/consul-template/config.d/watch.hcl.erb'),
    notify  => Service['consul_template'],
  }
}
