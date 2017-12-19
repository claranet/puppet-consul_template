node default {

  ensure_packages('unzip')

  class { '::consul_template':
    version       => '0.19.3',
    config_hash   => {
      log_level => 'debug',
      wait      => '5s:30s',
      max_stale => '1s'
    },
  }

  ::consul_template::watch { 'test':
    template    => 'consul_template/consul-template.upstart.erb',
    config_hash => {
      destination => '/tmp/template-test',
      command     => 'echo done'
    }
  }
}
