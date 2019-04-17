# == Class: consul_template
#
# Installs, configures, and manages consul-template
#
# === Parameters
#
# [*version*]
#   Specify version of consul-template binary to download.
#
# [*install_method*]
#   Defaults to `url` but can be `package` if you want to install via a system package.
#
# [*package_name*]
#   Only valid when the install_method == package. Defaults to `consul-template`.
#
# [*package_ensure*]
#   Only valid when the install_method == package. Defaults to `latest`.
#
# [*extra_options*]
#   Extra arguments to be passed to the consul-template agent
#
# [*init_style*]
#   What style of init system your system uses. Set to 'unmanaged' to not create a service file.
#
# [*config_hash*]
#   Consul-template configuration options. See https://github.com/hashicorp/consul-template#options
#
# [*config_mode*]
#   Set config file mode
#
# [*purge_config_dir*]
#   Purge config files no longer generated by Puppet
#
# [*data_dir*]
#   Path to a directory to create to hold some data. Defaults to ''
#
# [*user*]
#   Name of a user to use for dir and file perms. Defaults to root.
#
# [*group*]
#   Name of a group to use for dir and file perms. Defaults to root.
#
# [*manage_user*]
#   User is managed by this module. Defaults to `false`.
#
# [*manage_group*]
#   Group is managed by this module. Defaults to `false`.
#
# [*watches*]
#   A hash of watches - allows greater Hiera integration. Defaults to `{}`.
class consul_template (
  String $arch                               = $consul_template::params::arch,
  String $init_style                         = $consul_template::params::init_style,
  String $os                                 = $consul_template::params::os,
  String $bin_dir                            = '/usr/local/bin',
  Hash $config_hash                          = {},
  Hash $config_defaults                      = {},
  String $config_dir                         = '/etc/consul-template',
  String $config_mode                        = '0660',
  String $data_dir                           = '',
  Optional[Stdlib::HTTPSUrl] $download_url   = undef,
  Stdlib::HTTPSUrl $download_url_base        = 'https://releases.hashicorp.com/consul-template',
  String $download_extension                 = 'zip',
  String $extra_options                      = '',
  String $group                              = 'root',
  Enum['url', 'package'] $install_method     = 'url',
  String $logrotate_compress                 = 'nocompress',
  Integer $logrotate_files                   = 4,
  Boolean $logrotate_on                      = false,
  String $logrotate_period                   = 'daily',
  Boolean $manage_user                       = false,
  Boolean $manage_group                      = false,
  String $package_name                       = 'consul-template',
  String $package_ensure                     = 'latest',
  Boolean $pretty_config                     = false,
  Integer $pretty_config_indent              = 4,
  Boolean $purge_config_dir                  = true,
  Boolean $service_enable                    = true,
  Enum['stopped', 'running'] $service_ensure = 'running',
  String $user                               = 'root',
  String $version                            = '0.19.4',
  Hash $watches                              = {},
) inherits consul_template::params {

  $_download_url = pick($download_url, "${download_url_base}/${version}/${package_name}_${version}_${os}_${arch}.${download_extension}")

  if $watches {
    create_resources('consul_template::watch', $watches)
  }

  contain consul_template::install
  contain consul_template::config
  contain consul_template::service
  contain consul_template::logrotate

  Class['consul_template::install']
  -> Class['consul_template::config']
  ~> Class['consul_template::service']
  -> Class['consul_template::logrotate']

}
