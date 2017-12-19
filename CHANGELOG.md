# Change Log

Release notes for the claranet/puppet-varnish module.

------------------------------------------

## 2.0.0 - 2017-12-19

### Breaking/Backwards-Incompatible Changes - Puppet 4 Syntax

  * Parameters are validated against Puppet 4 data types
  * Stdlib version requirements have been raised
  * Restructure class inclusion by replacing anchor pattern with 'contain' and class ordering
  * Rename `$::foo` to `$foo`
  * Switch to structured facts
  * Move from `$foo_real` to `$_foo` pattern
  * Thanks to [Will Yardley](https://github.com/wyardley) for raising [#108](https://github.com/claranet/puppet-consul_template/pull/108)

## 1.0.1 - 2017-12-19

### Bug Fix and Deprecation

  * This is the last version of the module to be released with compatibility for Puppet 3
  * Backported fix for [#115](https://github.com/claranet/puppet-consul_template/issues/115)

## 1.0.0 - 2017-12-07

### Breaking/Backwards-Incompatible Changes

 * Use `config_hash` for most config options deprecating many parameters, based
   on changes made in github/consul_template fork ([#110](https://github.com/claranet/puppet-consul_template/issues/110) / [#111](https://github.com/claranet/puppet-consul_template/issues/111)). Thanks to ross
   and GitHub for allowing this to be adopted back upstream.
 * Drop support for very old OSes like RHEL/CentOS 5, etc.
 * Now depends on `KyleAnderson/consul` module for `consul_sorted_json` function.
 * Deprecated the following parameters:
   - `consul_host`
   - `consul_port`
   - `consul_token`
   - `consul_retry`
   - `consul_retry_attempts`
   - `consul_retry_backoff`
   - `consul_wait`
   - `consul_max_stale`
   - `deduplicate`
   - `deduplicate_prefix`
   - `log_level`
   - `vault_enabled`
   - `vault_address`
   - `vault_token`
   - `vault_ssl`
   - `vault_ssl_verify`
   - `vault_ssl_cert`
   - `vault_ssl_ca_cert`
   - `consul_reload_signal`
   - `consul_kill_signal`
   - `consul_ssl_enabled`
   - `consul_ssl_verify`
   - `consul_ssl_cert`
   - `consul_ssl_ca_cert`
 * Added parameters:
   - `pretty_config`
   - `pretty_config_indent`
   - `config_hash`
   - `config_defaults`

## 0.2.9 - 2016-11-01
  * Feature Enhancement: Change consul-tempalte systemd restart option

## 0.2.8 - 2016-05-11
  * Bugfix: Revert: Do not create the user  group by default. Run consul-template as root/root instead

## 0.2.7 - 2016-05-11
  * Pulled

## 0.2.6 - 2016-05-11
  * Bugfix: Create the user  group by default, else we can't chown the install directory [#70](https://github.com/claranet/puppet-consul_template/issues/70)

## 0.2.5 - 2016-03-31
  * Feature: Support logrotate through `logrotate_on` [#50](https://github.com/claranet/puppet-consul_template/issues/50)
  * Feature: Support watches definition in Hiera [#59](https://github.com/claranet/puppet-consul_template/issues/59)
  * Bugfix: Don't use root if we launch through Upstart or Systemd [#51](https://github.com/claranet/puppet-consul_template/issues/51) [#60](https://github.com/claranet/puppet-consul_template/issues/60)
  * Bugfix: Allow both or neither of `template` and `source` to be set [#52](https://github.com/claranet/puppet-consul_template/issues/52)
  * Bugfix: Anchors to improve dependency resolution [#62](https://github.com/claranet/puppet-consul_template/issues/62) [#63](https://github.com/claranet/puppet-consul_template/issues/63)
  * Bugfix: All `consul_template` releases are now zipfiles - remove `strip` arg [#65](https://github.com/claranet/puppet-consul_template/issues/65)

## 0.2.4 - 2015-12-17
  * Feature: Use releases.hashicorp.com download URL [#42](https://github.com/claranet/puppet-consul_template/issues/42)
  * Feature: Better UNIX permissions on config/template files [#43](https://github.com/claranet/puppet-consul_template/issues/43)
  * Feature: Specify existing source file location for watches [#45](https://github.com/claranet/puppet-consul_template/issues/45)
  * Bugfix: config param name should be max_stale rather than max-stale [#46](https://github.com/claranet/puppet-consul_template/issues/46)

## 0.2.3 - 2015-10-22
  * Bugfix: downloading older versions of Consul Template works again [#39](https://github.com/claranet/puppet-consul_template/issues/39)

## 0.2.2 - 2015-10-19
  * Support upgrades of Consul Template on the same machine [#37](https://github.com/claranet/puppet-consul_template/issues/37)

## 0.2.1 - 2015-10-19
  * Support for Consul Template 0.11.0 [#34](https://github.com/claranet/puppet-consul_template/issues/34) [#36](https://github.com/claranet/puppet-consul_template/issues/36)
  * Add more parameters [#23](https://github.com/claranet/puppet-consul_template/issues/23) [#25](https://github.com/claranet/puppet-consul_template/issues/25) [#33](https://github.com/claranet/puppet-consul_template/issues/33)

## 0.2.0 - 2015-07-03
  * Better init/startup scripts [#3](https://github.com/claranet/puppet-consul_template/issues/3) [#4](https://github.com/claranet/puppet-consul_template/issues/4) [#8](https://github.com/claranet/puppet-consul_template/issues/8) [#13](https://github.com/claranet/puppet-consul_template/issues/13)
  * Restart consul-template on changes to its main config [#16](https://github.com/claranet/puppet-consul_template/issues/16)
