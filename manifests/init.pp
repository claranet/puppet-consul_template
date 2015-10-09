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
#   What style of init system your system uses.
#
# [*purge_config_dir*]
#   Purge config files no longer generated by Puppet
#
# [*vault_enabled*]
#   Do we want to configure Hashicopr Vault? Defaults to false.
#
# [*vault_address*]
#   HTTP/HTTPS URL of the vault service
#
# [*vault_token*]
#   Auth token to use for Vault
#
# [*vault_ssl*]
#   Should we use SSL? Defaults to true
#
# [*vault_ssl_verify*]
#   Should we verify the SSL certificate? Defaults to true
#
# [*vault_ssl_cert*]
#   What is the path to the cert.pem
#
# [*vault_ssl_ca_cert*]
#   What is the path to the ca cert.pem
#
# [*data_dir*]
#   Path to a directory to create to hold some data. Defaults to ''
#
# [*manage_user*]
#   Name of a user to create if it does not exist. Defaults to ''
#
# [*manage_group*]
#   Name of a group to create if it does not exist. Defaults to ''

class consul_template (
  $purge_config_dir  = true,
  $bin_dir           = '/usr/local/bin',
  $arch              = $consul_template::params::arch,
  $version           = $consul_template::params::version,
  $install_method    = $consul_template::params::install_method,
  $os                = $consul_template::params::os,
  $download_url      = "https://github.com/hashicorp/consul-template/releases/download/v${version}/consul_template_${version}_${os}_${arch}.tar.gz",
  $package_name      = $consul_template::params::package_name,
  $package_ensure    = $consul_template::params::package_ensure,
  $config_dir        = '/etc/consul-template',
  $extra_options     = '',
  $service_enable    = true,
  $service_ensure    = 'running',
  $consul_host       = 'localhost',
  $consul_port       = '8500',
  $consul_token      = '',
  $consul_retry      = '10s',
  $consul_wait       = undef,
  $init_style        = $consul_template::params::init_style,
  $log_level         = $consul_template::params::log_level,
  $vault_enabled     = false,
  $vault_address     = '',
  $vault_token       = '',
  $vault_ssl         = true,
  $vault_ssl_verify  = true,
  $vault_ssl_cert    = '',
  $vault_ssl_ca_cert = '',
  $data_dir          = '',
  $manage_user       = '',
  $manage_group      = '',
) inherits ::consul_template::params {

  validate_bool($purge_config_dir)

  class { '::consul_template::install': } ->
  class { '::consul_template::config':
    consul_host  => $consul_host,
    consul_port  => $consul_port,
    consul_token => $consul_token,
    consul_retry => $consul_retry,
    purge        => $purge_config_dir,
  } ~>
  class { '::consul_template::service': } ->
  Class['::consul_template']
}
