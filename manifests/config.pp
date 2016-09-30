# == Class consul_template::config
#
# This class is called from consul_template for service config.
#
class consul_template::config {
  file { [$::consul_template::config_dir, "${::consul_template::config_dir}/config"]:
    ensure  => 'directory',
    purge   => $::consul_template::purge_config_dir,
    recurse => $::consul_template::purge_config_dir,
    owner   => $::consul_template::user,
    group   => $::consul_template::group,
    mode    => '0755',
  }

  concat { 'consul-template/config.json':
    path   => "${::consul_template::config_dir}/config/config.json",
    owner  => $::consul_template::user,
    group  => $::consul_template::group,
    mode   => $::consul_template::config_mode,
    notify => Service['consul-template'],
  }

  concat::fragment { 'consul-template/config.json+00-main':
    target  => 'consul-template/config.json',
    order   => '00',
    content => template('consul_template/config.json/00_main.erb'),
  }

  if $::consul_template::auth_enabled {
    concat::fragment { 'consul-template/config.json+10-auth':
      target  => 'consul-template/config.json',
      order   => '10',
      content => template('consul_template/config.json/10_auth.erb'),
    }
  }

  if $::consul_template::real_deduplicate_enabled {
    concat::fragment { 'consul-template/config.json+20-deduplicate':
      target  => 'consul-template/config.json',
      order   => '20',
      content => template('consul_template/config.json/20_deduplicate.erb'),
    }
  }

  if $::consul_template::exec_command {
    concat::fragment { 'consul-template/config.json+30-exec':
      target  => 'consul-template/config.json',
      order   => '30',
      content => template('consul_template/config.json/30_exec.erb'),
    }
  }

  if $::consul_template::ssl_enabled {
    concat::fragment { 'consul-template/config.json+40-ssl':
      target  => 'consul-template/config.json',
      order   => '40',
      content => template('consul_template/config.json/40_ssl.erb'),
    }
  }

  if $::consul_template::syslog_enabled {
    concat::fragment { 'consul-template/config.json+50-syslog':
      target  => 'consul-template/config.json',
      order   => '50',
      content => template('consul_template/config.json/50_syslog.erb'),
    }
  }

  if $::consul_template::vault_enabled {
    concat::fragment { 'consul-template/config.json+60-vault':
      target  => 'consul-template/config.json',
      order   => '60',
      content => template('consul_template/config.json/60_vault/main.erb'),
    }
  }
}
