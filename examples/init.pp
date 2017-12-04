node default {
  class { '::consul_template':
    version       => '0.19.3',
    pretty_config => true,
    config_hash   => {
      log_level => 'debug',
      wait      => '5s:30s',
      max_stale => '1s'
    },
  }
}
