# == Class consul_template::params
#
# This class is meant to be called from consul_template.
# It sets variables according to platform.
#
class consul_template::params {

  $os = downcase($facts['kernel'])

  case $facts['architecture'] {
    'x86_64', 'amd64': {
      $arch = 'amd64'
    }

    'i386': {
      $arch = '386'
    }

    default:           {
      fail("Unsupported kernel architecture: ${facts['architecture']}")
    }
  }

  $init_style = $facts['os']['name'] ? {
    'Ubuntu' => $facts['os']['release']['major'] ? {
      '15.04' => 'systemd',
      '16.04' => 'systemd',
      default => 'upstart'
    },

    /CentOS|RedHat/ => $facts['os']['release']['major'] ? {
      '6' => 'sysv',
      default   => 'systemd',
    },
    'Fedora'        => $facts['os']['release']['major'] ? {
      /(12|13|14)/ => 'sysv',
      default      => 'systemd',
    },
    'Debian'        =>  $facts['os']['release']['major'] ? {
      '7' => 'debian',
      default     => 'systemd'
    },

    default => 'sysv'
  }
}
