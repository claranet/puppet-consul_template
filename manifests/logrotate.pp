# == Class consul_template::logrotate
#
class consul_template::logrotate(
  $logrotate_compress,
  $logrotate_files,
  $logrotate_on,
  $logrotate_period,
) {
  validate_string($logrotate_compress)
  validate_integer($logrotate_files)
  validate_bool($logrotate_on)
  validate_string($logrotate_period)

  if $logrotate_on {
    file { '/etc/logrotate.d/consul-template':
      ensure  => present,
      content => template("${module_name}/consul-template.logrotate.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
    }
  }

}
