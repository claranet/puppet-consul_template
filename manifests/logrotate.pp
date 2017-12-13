# == Class consul_template::logrotate
#
class consul_template::logrotate(
  $logrotate_compress     = $consul_template::logrotate_compress,
  $logrotate_files        = $consul_template::logrotate_files,
  $logrotate_on           = $consul_template::logrotate_on,
  $logrotate_period       = $consul_template::logrotate_period,
  String $restart_sysv    = '/sbin/service consul-template restart',
  String $restart_systemd = '/bin/systemctl restart consul-template.service',
) {

  case $facts['os']['family'] {
    'RedHat': {
      case $facts['os']['name'] {
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific': {
          if(versioncmp($facts['os']['release']['major'], '7') > 0) {
            $postrotate_command = $restart_systemd
          }
          elsif (versioncmp($facts['os']['release']['major'], '7') < 0) {
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
