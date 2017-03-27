# == Class: consul_template
#
# Installs, configures and manages consul-template
#
# === Parameters
#
# [*arch*]
#   Sets the architecture of consul-template binary to download.
#   Default depends on operating system.
#
# [*auth_enabled*]
#   Whether to enable http basic auth when sending requests to consul.
#   Defaults to `undef`
#
# [*auth_username*]
#   Sets the username to use with http basic auth.
#   Defaults to `undef`
#
# [*auth_password*]
#   Sets the password to use with http basic auth.
#   Defaults to `undef`
#
# [*bin_dir*]
#   Sets the directory  to create the symlink to the consul-teomplate binary in.
#   Defaults to `/usr/local/bin`
#
# [*config_dir*]
#   Sets the directory to install consul-template configuration files in.
#   Defaults to `/etc/consul-template`
#
# [*config_mode*]
#   Sets the file mode of the consul-template configuration file.
#   Defaults to `0660`
#
# [*consul_host*]
#   Sets the address of the consul agent to connect to.
#   Defaults to `localhost`
#
# [*consul_max_stale*]
#   Sets the maximum interval to allow "stale" data from consul.
#   Defaults to `localhost`
#
# [*consul_port*]
#   Sets the port of the consul agent to connect to.
#   Defaults to `8500`
#
# [*consul_retry*]
#   Sets the amount of time to wait before retrying a connection to consul.
#   Defaults to `undef`
#
# [*consul_token*]
#   Sets the the ACL token to use when connecting to consul.
#   Defaults to `undef`
#
# [*consul_wait*]
#   Sets the the minimum and maximum amount of time to wait for the cluster to
#   reach a consistent state before rendering a template.
#   Defaults to `undef`
#
# [*data_dir*]
#   Path to a directory to create to hold some data.
#   Defaults to `undef`
#
# [*deduplicate*]
#   DEPRECATED: Use `deduplicate_enabled` instead.
#
# [*deduplicate_enabled*]
#   Whether to enable consul-template's deduplication mode.
#   Defaults to `undef`
#
# [*deduplicate_prefix*]
#   Sets the prefix to the path in consul's KV store where de-duplication
#   templates will be pre-rendered and stored.
#   Defaults to `undef`
#
# [*download_extension*]
#   The extension of the archive file containing the consul-template binary to
#   download.
#   Defaults to `zip`
#
# [*download_url*]
#   Fully qualified url to the location of the archive file containing the
#   consul-template binary.
#   Defaults to `undef`
#
# [*download_url_base*]
#   Base url to the location of the archive file containing the consul-template
#   binary.
#   Defaults to `https://releases.hashicorp.com/consul-template/`
#
# [*dump_signal*]
#   Sets the signal to listen for to trigger a core dump event.
#   Defaults to `undef`
#
# [*exec_command*]
#   Sets the command to exec as a child process.
#   Defaults to `undef`
#
# [*exec_kill_signal*]
#   Sets the signal sent to the child process when Consul Template is
#   gracefully shutting down.
#   Defaults to `undef`
#
# [*exec_kill_timeout*]
#   Sets the amount of time to wait for the child process to gracefully
#   terminate when Consul Template exits.
#   Defaults to `undef`
#
# [*exec_reload_signal*]
#   Sets the signal that will be sent to the child process when a change occurs
#   in a watched template.
#   Defaults to `undef`
#
# [*exec_splay*]
#   Sets the random splay to wait before killing the command.
#   Defaults to `undef`
#
# [*extra_options*]
#   Extra arguments to be passed to the consul-template agent
#   Defaults to ''
#
# [*group*]
#   Name of a group to use for dir and file perms.
#   Defaults to `root`
#
# [*init_style*]
#   What style of init system your system uses. Set to 'unmanaged' to disable
#   managing init system files for the consul-template service entirely.
#   Default depends on operating system.
#
# [*install_method*]
#   Valid strings: `package` - install via system package
#                  `url`     - download and extract from a url.
#   Defaults to `url`
#
# [*kill_signal*]
#   Sets the signal to listen for to trigger a graceful stop.
#   Defaults to `undef`
#
# [*log_level*]
#   Sets the log level of consul-template.
#   Defaults to `undef`
#
# [*logrotate_compress*]
#   Sets the logrotate compress parameter for consul-template's log files.
#   Defaults to `nocompress`
#
# [*logrotate_files*]
#   Sets the logrotate rotate parameter for consul-template's log file.
#   Defaults to `4`
#
# [*logrotate_on*]
#   Whether to install a logrotate configuration for consul-template's log file.
#   Defaults to `false`
#
# [*logrotate_period*]
#   Sets the logrotate period parameter for consul-template's log file.
#   Defaults to `daily`
#
# [*manage_group*]
#   Whether to create/manage the group that should own the consul configuration
#   files.
#   Defaults to `false`
#
# [*manage_user*]
#   Whether to create/manage the user that should own consul's configuration
#   files. 
#   Defaults to `false`
#
# [*os*]
#   OS component in the name of the archive file containing the consul binary.
#   Default depends on operating system.
#
# [*package_ensure*]
#   Only valid when the install_method == package.
#   Defaults to `latest`
#
# [*package_name*]
#   Only valid when the install_method == package.
#   Defaults to `consul-template`
#
# [*purge_config_dir*]
#   Whether to purge unmanaged files from consul-template's configuration
#   directory.
#   Defaults to `true`
#
# [*reload_signal*]
#   Sets the signal to listen for to trigger a reload event.
#   Defaults to `undef`
#
# [*service_enable*]
#   Whether to enable the consul-template service to start at boot.
#   Defaults to `true`
#
# [*service_ensure*]
#   Whether the consul-template service should be running or not.
#   Defaults to `running`.
#
# [*ssl_enabled*]
#   Whether to enabled ssl for connections to consul.
#   Defaults to `true`
#
# [*ssl_ca_cert*]
#   Sets the path to the ssl ca certificate to use when connecting to consul.
#
# [*ssl_cert*]
#   Sets the path to the ssl certificate to use when connecting to consul.
#
# [*ssl_key*]
#   Sets the path to the ssl key to use when connecting to consul.
#
# [*ssl_verify*]
#   Whether to enable ssl peer verification when connecting to consul.
#   Defaults to `true`
#
# [*syslog_enabled*]
#   Whether to enable sysloging.
#   Defaults to `false`.
#
# [*syslog_facility*]
#   Sets the name of the syslog facility to log to.
#   Defaults to `undef`.
#
# [*user*]
#   Name of a user to use for dir and file perms. Defaults to root.
#
# [*vault_address*]
#   Sets the address of the vault leader. 
#
# [*vault_enabled*]
#   Whether to enable vault.
#   Defaults to `false`
#
# [*vault_renew_token*]
#   Whether to automatically renew the vault token.
#   Defaults to `undef`
#
# [*vault_ssl*]
#   DEPRECATED: Use `vault_ssl_enabled` instead.
#
# [*vault_ssl_enabled*]
#   Whether to use ssl for connections to vault.
#   Defaults to `undef`
#
# [*vault_ssl_ca_cert*]
#   Sets the path to the ssl ca certificate to use when connecting to vault.
#
# [*vault_ssl_cert*]
#   Sets the path to the ssl certificate to use when connecting to vault.
#
# [*vault_ssl_key*]
#   Sets the path to the ssl certificate to use when connecting to vault.
#
# [*vault_ssl_verify*]
#   Whether to enable ssl peer verification when connecting to vault.
#   Defaults to `true`
#
# [*vault_token*]
#   Sets the token to use when communicating with the vault server.
#   Defaults to `undef`
#
# [*vault_unwrap_token*]
#   Whether to unwrap vault token before use.
#   Defaults to `undef`
#
# [*version*]
#   Specifies version of consul-template binary to download.
#   Defaults to `0.11.0`
#
# [*watches*]
#   Hash of consul_template::watch resources to create.
#   Defaults to `{}`
#
# === Examples
#
#  @example
#    class { '::consul_template':
#      consul_max_stale => '1s'
#      consul_wait      => '5s:30s',
#      init_style       => 'upstart',
#      log_level        => 'debug',
#      service_enable   => false
#    }
#
class consul_template (
  $arch                         = $::consul_template::params::arch,
  $auth_enabled                 = $::consul_template::params::auth_enabled,
  $auth_password                = $::consul_template::params::auth_password,
  $auth_username                = $::consul_template::params::auth_username,
  $bin_dir                      = $::consul_template::params::bin_dir,
  $config_dir                   = $::consul_template::params::config_dir,
  $config_mode                  = $::consul_template::params::config_mode,
  $consul_host                  = $::consul_template::params::consul_host,
  $consul_max_stale             = $::consul_template::params::consul_max_stale,
  $consul_port                  = $::consul_template::params::consul_port,
  $consul_retry                 = $::consul_template::params::consul_retry,
  $consul_token                 = $::consul_template::params::consul_token,
  $consul_wait                  = $::consul_template::params::consul_wait,
  $data_dir                     = $::consul_template::params::data_dir,
  $deduplicate                  = undef,  # deprecated
  $deduplicate_enabled          = $::consul_template::params::deduplicate_enabled,
  $deduplicate_prefix           = $::consul_template::params::deduplicate_prefix,
  $download_extension           = $::consul_template::params::download_extension,
  $download_url                 = $::consul_template::params::download_url,
  $download_url_base            = $::consul_template::params::download_url_base,
  $dump_signal                  = $::consul_template::params::dump_signal,
  $exec_command                 = $::consul_template::params::exec_command,
  $exec_kill_signal             = $::consul_template::params::exec_kill_signal,
  $exec_kill_timeout            = $::consul_template::params::exec_kill_timeout,
  $exec_reload_signal           = $::consul_template::params::exec_reload_signal,
  $exec_splay                   = $::consul_template::params::exec_splay,
  $extra_options                = $::consul_template::params::extra_options,
  $group                        = $::consul_template::params::group,
  $init_style                   = $::consul_template::params::init_style,
  $install_method               = $::consul_template::params::install_method,
  $kill_signal                  = $::consul_template::params::kill_signal,
  $log_level                    = $::consul_template::params::log_level,
  $logrotate_compress           = $::consul_template::params::logrotate_compress,
  $logrotate_files              = $::consul_template::params::logrotate_files,
  $logrotate_on                 = $::consul_template::params::logrotate_on,
  $logrotate_period             = $::consul_template::params::logrotate_period,
  $logrotate_postrotate_command =
    $::consul_template::params::logrotate_postrotate_command,
  $manage_group                 = $::consul_template::params::manage_group,
  $manage_user                  = $::consul_template::params::manage_user,
  $os                           = $::consul_template::params::os,
  $package_ensure               = $::consul_template::params::package_ensure,
  $package_name                 = $::consul_template::params::package_name,
  $pid_file                     = $::consul_template::params::pid_file,
  $purge_config_dir             = $::consul_template::params::purge_config_dir,
  $reload_signal                = $::consul_template::params::reload_signal,
  $service_enable               = $::consul_template::params::service_enable,
  $service_ensure               = $::consul_template::params::service_ensure,
  $ssl_ca_cert                  = $::consul_template::params::ssl_ca_cert,
  $ssl_cert                     = $::consul_template::params::ssl_cert,
  $ssl_enabled                  = $::consul_template::params::ssl_enabled,
  $ssl_key                      = $::consul_template::params::ssl_key,
  $ssl_verify                   = $::consul_template::params::ssl_verify,
  $syslog_enabled               = $::consul_template::params::syslog_enabled,
  $syslog_facility              = $::consul_template::params::syslog_facility,
  $user                         = $::consul_template::params::user,
  $vault_address                = $::consul_template::params::vault_address,
  $vault_enabled                = $::consul_template::params::vault_enabled,
  $vault_renew_token            = $::consul_template::params::vault_renew_token,
  $vault_ssl                    = undef,  # deprecated
  $vault_ssl_enabled            = $::consul_template::params::vault_ssl_enabled,
  $vault_ssl_ca_cert            = $::consul_template::params::vault_ssl_ca_cert,
  $vault_ssl_cert               = $::consul_template::params::vault_ssl_cert,
  $vault_ssl_key                = $::consul_template::params::vault_ssl_key,
  $vault_ssl_verify             = $::consul_template::params::vault_ssl_verify,
  $vault_token                  = $::consul_template::params::vault_token,
  $vault_unwrap_token           = $::consul_template::params::vault_unwrap_token,
  $version                      = $::consul_template::params::version,
  $watches                      = $::consul_template::params::watches,
) inherits ::consul_template::params {
  class { '::consul_template::validate_params': }

  $real_deduplicate_enabled = $deduplicate_enabled or $deduplicate
  $real_vault_ssl_enabled = $vault_ssl_enabled or $vault_ssl

  $real_download_url = pick($download_url, "${download_url_base}${version}/${package_name}_${version}_${os}_${arch}.${download_extension}")

  if $watches {
    create_resources(consul_template::watch, $watches)
  }

  anchor { '::consul_template::begin': } ->
  class { '::consul_template::install': } ->
  class { '::consul_template::config': } ~>
  class { '::consul_template::service': } ->
  anchor { '::consul_template::end': }

  if $logrotate_on {
    class { '::consul_template::logrotate':
      compress           => $logrotate_compress,
      files              => $logrotate_files,
      period             => $logrotate_period,
      postrotate_command => $logrotate_postrotate_command,
      require            => Anchor['::consul_template::begin'],
      before             => Anchor['::consul_template::end'],
    }
  }
}
