# == Class consul_template::validate_params
#
# This class is called from consul_template for class parameter validation.
#
class consul_template::validate_params {
  validate_bool($::consul_template::logrotate_on)
  validate_bool($::consul_template::manage_group)
  validate_bool($::consul_template::manage_user)
  validate_bool($::consul_template::purge_config_dir)
  validate_hash($::consul_template::watches)
  validate_string($::consul_template::user)
  validate_string($::consul_template::group)

  if $::consul_template::auth_enabled != undef {
    validate_bool($::consul_template::auth_enabled)
  }

  if $::consul_template::deduplicate_enabled != undef {
    validate_bool($::consul_template::deduplicate_enabled)
  }

  if $::consul_template::ssl_enabled != undef {
    validate_bool($::consul_template::ssl_enabled)
  }

  if $::consul_template::ssl_verify != undef {
    validate_bool($::consul_template::ssl_verify)
  }

  if $::consul_template::syslog_enabled != undef {
    validate_bool($::consul_template::syslog_enabled)
  }

  if $::consul_template::vault_renew_token != undef {
    validate_bool($::consul_template::vault_renew_token)
  }

  if $::consul_template::vault_ssl_enabled != undef {
    validate_bool($::consul_template::vault_ssl_enabled)
  }

  if $::consul_template::vault_ssl_verify != undef {
    validate_bool($::consul_template::vault_ssl_verify)
  }

  if $::consul_template::vault_unwrap_token != undef {
    validate_bool($::consul_template::vault_unwrap_token)
  }

  if $::consul_template::deduplicate != undef {
      warning('The $::consul_template::deduplicate parameter is deprecated, please use $::consul_template::deduplicate_enabled instead')
      validate_bool($::consul_template::deduplicate)
  }
  if $::consul_template::vault_ssl != undef {
      warning('The $::consul_template::vault_ssl parameter is deprecated, please use $::consul_template::vault_ssl_enabled instead')
      validate_bool($::consul_template::vault_ssl)
  }
}
