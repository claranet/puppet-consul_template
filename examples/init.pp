node default {

  # == Consul itself

  class { '::consul':
    version       => '0.8.5',
    extra_options => "-advertise ${facts[networking][ip]}",
    config_hash   => {
      bootstrap_expect => 1,
      client_addr      => '0.0.0.0',
      data_dir         => '/opt/consul',
      datacenter       => 'vagrant',
      log_level        => 'DEBUG',
      node_name        => 'server',
      server           => true,
      ui_dir           => '/opt/consul/ui',
    },
  }

  # == Nginx server and basic Consul service

  class { '::nginx': }

  ::consul::service { 'nginx':
    port   => 80,
    tags   => ['master'],
    checks => [ {
      script   => '/usr/bin/curl http://127.0.0.1',
      interval => '10s'
    }]
  }

  # == Basic key/value

  consul_key_value { 'mykey/path':
    ensure     => 'present',
    value      => 'myvaluestring',
    datacenter => 'vagrant'
  }


  # == Consul-template

  class { '::consul_template':
    version       => '0.19.3',
    pretty_config => true,
    require       => Service['consul'],
    config_hash   => {
      consul    => {
        token => '',
        retry => {
          attempts => 5,
          backoff  => '250ms'
        }
      },
      log_level => 'debug',
      wait      => '5s:30s',
      max_stale => '1s'
    },
  }
}
