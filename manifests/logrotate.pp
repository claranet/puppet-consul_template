# == Class consul_template::logrotate
#
class consul_template::logrotate(
  $compress           = $::consul_template::params::logrotate_compress,
  $files              = $::consul_template::params::logrotate_files,
  $period             = $::consul_template::params::logrotate_period,
  $postrotate_command = $::consul_template::params::logrotate_postrotate_command,
) inherits ::consul_template::params {
  validate_string($compress)
  validate_integer($files)
  validate_string($period)
  validate_string($postrotate_command)

  file { '/etc/logrotate.d/consul-template':
    ensure  => present,
    content => template('consul_template/consul-template.logrotate.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
