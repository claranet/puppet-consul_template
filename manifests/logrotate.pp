# == Class consul_template::logrotate
#
class consul_template::logrotate(
  $logrotate_compress,
  $logrotate_files,
  $logrotate_on,
  $logrotate_period,
  $restart_sysv = '/sbin/service consul-template restart',
  $restart_systemd = '/bin/systemctl restart consul-template.service',
) {
  validate_string($logrotate_compress)
  validate_integer($logrotate_files)
  validate_bool($logrotate_on)
  validate_string($logrotate_period)
  validate_string($restart_sysv)
  validate_string($restart_systemd)

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific': {
          if(versioncmp($::operatingsystemmajrelease, '7') > 0) {
            $postrotate_command = $restart_systemd
          }
          elsif (versioncmp($::operatingsystemmajrelease, '7') < 0) {
            $postrotate_command = $restart_sysv
          }
          else {
            $postrotate_command = $restart_systemd
          }
        }
        'Amazon': {
          $postrotate_command = $restart_sysv
        }
        default: {
          $postrotate_command = $restart_sysv
        }
      }
    }
    default: {
      $postrotate_command = $restart_sysv
    }
  }

  if $logrotate_on {
    file { '/etc/logrotate.d/consul-template':
      ensure  => file,
      content => template("${module_name}/consul-template.logrotate.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

}
