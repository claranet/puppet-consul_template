# == Class consul_template::params
#
# This class is meant to be called from consul_template.
# It sets variables according to platform.
#
class consul_template::params {

  $bin_dir            = '/usr/local/bin'
  $config_dir         = '/etc/consul-template'
  $config_mode        = '0660'
  $consul_host        = 'localhost'
  $consul_max_stale   = undef
  $consul_port        = '8500'
  $consul_retry       = '10s'
  $consul_token       = ''
  $consul_wait        = undef
  $data_dir           = ''
  $deduplicate        = false
  $deduplicate_prefix = undef
  $download_extension = 'zip'
  $download_url       = undef
  $download_url_base  = 'https://releases.hashicorp.com/consul-template/'
  $extra_options      = ''
  $group              = 'root'
  $install_method     = 'url'
  $log_level          = 'info'
  $logrotate_compress = 'nocompress'
  $logrotate_files    = 4
  $logrotate_on       = false
  $logrotate_period   = 'daily'
  $manage_group       = false
  $manage_user        = false
  $package_ensure     = 'latest'
  $package_name       = 'consul-template'
  $purge_config_dir   = true
  $service_enable     = true
  $service_ensure     = 'running'
  $user               = 'root'
  $vault_address      = ''
  $vault_enabled      = false
  $vault_ssl          = true
  $vault_ssl_ca_cert  = ''
  $vault_ssl_cert     = ''
  $vault_ssl_verify   = true
  $vault_token        = ''
  $version            = '0.11.0'
  $watches            = {}

  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           { fail("Unsupported kernel architecture: ${::architecture}") }
  }

  $os = downcase($::kernel)

  $init_style = $::operatingsystem ? {
    'Ubuntu'  => $::lsbdistrelease ? {
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
