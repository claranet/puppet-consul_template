# == Class consul_template::params
#
# This class is meant to be called from consul_template.
# It sets variables according to platform.
#
class consul_template::params {

  $install_method     = 'url'
  $log_level          = 'info'
  $package_name       = 'consul-template'
  $package_ensure     = 'latest'
  $version            = '0.11.0'
  $download_url_base  = 'https://releases.hashicorp.com/consul-template/'
  $download_extension = 'zip'
  $user               = 'root'
  $group              = 'root'
  $manage_user        = false
  $manage_group       = false
  $config_mode        = '0660'
  $kill_signal        = 'SIGTERM'
  $reload_signal      = 'SIGHUP'

#  case $facts['os']['architecture'] {
#    'x86_64', 'amd64': { $arch = 'amd64' }
#    'i386':            { $arch = '386'   }
#    default:           { fail("Unsupported kernel architecture: ${facts[os][architecture]}") }
#  }

  $arch = 'amd64'
  $os = downcase($facts['kernel'])

  $init_style = $facts['os']['name'] ? {
    'Ubuntu'  => $facts['os']['release']['major'] ? {
      '8.04'  => 'debian',
      '15.04' => 'systemd',
      '16.04' => 'systemd',
      default => 'upstart'
    },
    /CentOS|RedHat/      => $facts['os']['release']['major'] ? {
      /(4|5|6)/ => 'sysv',
      default   => 'systemd',
    },
    'Fedora'             => $facts['os']['release']['major'] ? {
      /(12|13|14)/ => 'sysv',
      default      => 'systemd',
    },
    'Debian'             =>  $facts['os']['release']['major'] ? {
      /(4|5|6|7)/ => 'debian',
      default     => 'systemd'
    },
    default => 'sysv'
  }
}
