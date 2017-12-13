# puppet-consul_template

[![Build Status](https://travis-ci.org/claranet/puppet-consul_template.svg?branch=master)](https://travis-ci.org/claranet/puppet-consul_template)

## Table of Contents

1. [Overview - What is the puppet-consul_template module?](#overview)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module:

* Installs the consul-template binary (via url or package)
* Optionally installs a user to run it under
* Installs a configuration file to `/etc/consul-template/config.json`
* Manages the consul-template service via upstart, sysv, or systemd

## Puppet 3 Support

**Please note that the master branch of this module does not support Puppet 3!**

On 31st December 2016, support for Puppet 3.x was withdrawn. As such, this module no longer supports Puppet 3 - if you require Puppet 3 compatibility, please use the latest version [1.x version from the Puppet Forge](https://forge.puppet.com/Claranet/consul_template), or the [puppet3](https://github.com/claranet/puppet-consul_template/tree/puppet3) branch in Git.

## Usage

The simplest way to use this module is:

```puppet
include ::consul_template
```

### Consul-template Options

consul-template options can be passed via hiera:

```yaml
consul_template::config_defaults:
  deduplicate:
    enabled: true
  log_level: info
  max_stale: 10m
  retry:
    attemtps: 12
    backoff: 250ms
  kill_signal: SIGINT
  reload_signal: SIGHUP
  retry: 10s
  syslog: true
  token: <consul token>
```

Or via class parameters:

```puppet
 class { 'consul_template':
   service_enable   => false
   config_hash      => {
     log_level => 'debug',
     wait      => '5s:30s',
     max_stale => '1s'
   }
 }
```

### Watch files

To declare a file that you wish to populate from Consul key-values, use the
`watch` define. This requires a source `.ctmpl` file and the file on-disk
that you want to update.

```puppet
consul_template::watch { 'common':
    template      => 'data/common.json.ctmpl.erb',
    template_vars => {
        'var1' => 'foo',
        'var2' => 'bar',
    },
    config_hash   => {
      perms       => '0644',
      destination => '/tmp/common.json',
      command     => 'true',
    },
}
```

### Full Parameter List

| Parameter              | Default                 | Description |
|------------------------|-------------------------|-------------|
| `purge_config_dir`     | `true`                  | If enabled, removes config files no longer managed by Puppet. |
| `config_mode`          | `0660`                  | Mode set on config files and directories. |
| `bin_dir`              | `/usr/local/bin`        | Path to the consul-template binaries |
| `arch`                 | Read from facter        | System architecture to use (amd64, x86_64, i386) |
| `version`              | `0.19.4`                | Version of consul-template to install via download |
| `install_method`       | `url`                   | When set to 'url', consul-template is downloaded and installed from source. If set to 'package', its installed using the system package manager. |
| `os`                   | Read from facter        |
| `download_url`         | `undef`                 | URL to download consul-template from (when `install_method` is set to 'url') |
| `download_url_base `   | `https://releases.hashicorp.com/consul-template` | Base URL to download consul-template from (when `install_method` is set to 'url') |
| `download_extension`   | `zip`                   | File extension of consul-template binary to be downloaded (when `install_method` is set to 'url') |
| `package_name`         | `consul-template`       | Name of package to install |
| `package_ensure`       | `latest`                | Version of package to install |
| `config_dir`           | `/etc/consul-template`  | Path to store the consul-template configuration |
| `extra_options`        | `''`                    | Extra options to be passed to the consul-template agent. See https://github.com/hashicorp/consul-template#options |
| `service_enable`       | `true                   | |
| `service_ensure`       | `running                | |
| `user`                 | `root`                  | This used to be a default of `consul-template` and this caused much out-of-box pain for people. |
| `group`                | `root`                  | |
| `manage_user`          | `false`                 | Module handles creating the user. |
| `manage_group`         | `false`                 | Module handles creating the group. |
| `init_style`           | See `params.pp`         | Init style to use for consul-template service.
| `log_level`            | `info`                  | Logging level to use for consul-template service. Can be 'debug', 'warn', 'err', 'info'
| `config_hash`          | `{}`                    | Consul-template configuration options. See https://github.com/hashicorp/consul-template#options
| `config_defaults`      | `{}`                    | Consul-template configuration option defaults.
| `pretty_config`        | `false`                 | Generates a human readable JSON config file. Defaults to `false`.
| `pretty_config_indent` | `4`                     | Toggle indentation for human readable JSON file.

## Limitations

Depends on the JSON gem, or a modern ruby.

## Development

* Copyright (C) 2017 Claranet
* Distributed under the terms of the Apache License v2.0 - see LICENSE file for details.
* To contribute, see the [contributing guide](CONTRIBUTING.md), then open an [issue](https://github.com/claranet/puppet-consul_template/issues) or
[fork](https://github.com/claranet/puppet-consul_template/fork) and open a
[Pull Request](https://github.com/claranet/puppet-consul_template/pulls)
