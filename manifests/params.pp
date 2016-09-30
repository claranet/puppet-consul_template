# == Class consul_template::params
#
# This class is meant to be called from consul_template.
# It sets variables according to platform.
#
class consul_template::params {

  $auth_enabled         = undef
  $auth_username        = undef
  $auth_password        = undef
  $bin_dir              = '/usr/local/bin'
  $config_dir           = '/etc/consul-template'
  $config_mode          = '0660'
  $consul_host          = 'localhost'
  $consul_max_stale     = undef
  $consul_port          = '8500'
  $consul_retry         = undef
  $consul_token         = undef
  $consul_wait          = undef
  $data_dir             = undef
  $deduplicate_enabled  = undef
  $deduplicate_prefix   = undef
  $download_extension   = 'zip'
  $download_url         = undef
  $download_url_base    = 'https://releases.hashicorp.com/consul-template/'
  $dump_signal          = undef
  $exec_command         = undef
  $exec_kill_signal     = undef
  $exec_kill_timeout    = undef
  $exec_reload_signal   = undef
  $exec_splay           = undef
  $extra_options        = ''
  $group                = 'root'
  $install_method       = 'url'
  $kill_signal          = undef
  $log_level            = undef
  $logrotate_compress   = 'nocompress'
  $logrotate_files      = 4
  $logrotate_on         = false
  $logrotate_period     = 'daily'
  $manage_group         = false
  $manage_user          = false
  $package_ensure       = 'latest'
  $package_name         = 'consul-template'
  $pid_file             = undef
  $purge_config_dir     = true
  $reload_signal        = undef
  $service_enable       = true
  $service_ensure       = 'running'
  $ssl_ca_cert          = undef
  $ssl_cert             = undef
  $ssl_enabled          = undef
  $ssl_key              = undef
  $ssl_verify           = undef
  $syslog_enabled       = undef
  $syslog_facility      = undef
  $user                 = 'root'
  $vault_address        = undef
  $vault_enabled        = undef
  $vault_renew_token    = undef
  $vault_ssl_enabled    = undef
  $vault_ssl_ca_cert    = undef
  $vault_ssl_cert       = undef
  $vault_ssl_key        = undef
  $vault_ssl_verify     = undef
  $vault_token          = undef
  $vault_unwrap_token   = undef
  $version              = '0.11.0'
  $watches              = {}

  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           { fail("Unsupported kernel architecture: ${::architecture}") }
  }

  $os = downcase($::kernel)

  $init_style = $::operatingsystem ? {
    'Ubuntu'  => $::operatingsystemmajrelease ? {
      '8.04'  => 'debian',
      '15.04' => 'systemd',
      default => 'upstart'
    },
    /CentOS|RedHat/      => $::operatingsystemmajrelease ? {
      /(4|5|6)/ => 'sysv',
      default   => 'systemd',
    },
    'Fedora'             => $::operatingsystemmajrelease ? {
      /(12|13|14)/ => 'sysv',
      default      => 'systemd',
    },
    'Debian'             => $::operatingsystemmajrelease ? {
      /(4|5|6|7)/ => 'debian',
      default     => 'systemd'
    },
    default => 'sysv'
  }

  $logrotate_postrotate_command = $init_style ? {
    'systemd' => '/bin/systemctl restart consul-template.service',
    default   => '/sbin/service consul-template restart'
  }
}
