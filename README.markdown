#consul_template for Puppet

### NOTICE:

This fork is not backwards compatible with its upstream. The configuration
mechanism has been modified to be driven by config_hash/config_defaults instead
of individual parameters to provide access to the full set of configuration
options and avoid the need to make changes here as consul-template options
evolve.

##Installation

###What This Module Affects

* Installs the consul-template binary (via url or package)
* Optionally installs a user to run it under
* Installs a configuration file (/etc/consul-template/config.json)
* Manages the consul-template service via upstart, sysv, or systemd


##Parameters

- `purge_config_dir` **Default**: true. If enabled, removes config files no longer managed by Puppet.
- `config_mode` **Default**: 0660. Mode set on config files and directories.
- `bin_dir` **Default**: /usr/local/bin. Path to the consul-template binaries
- `arch` **Default**: Read from facter. System architecture to use (amd64, x86_64, i386)
- `version` **Default**: 0.11.0. Version of consul-template to install
- `install_method` **Default**: url. When set to 'url', consul-template is downloaded and installed from source. If
set to 'package', its installed using the system package manager.
- `os` **Default**: Read from facter.
- `download_url` **Default**: undef. URL to download consul-template from (when `install_method` is set to 'url')
- `download_url_base ` **Default**: https://github.com/hashicorp/consul-template/releases/download/ Base URL to download consul-template from (when `install_method` is set to 'url')
- `download_extension` **Default**: zip. File extension of consul-template binary to be downloaded (when `install_method` is set to 'url')
- `package_name` **Default**: consul-template. Name of package to install
- `package_ensure` **Default**: latest.
- `config_dir` **Default**: /etc/consul-template. Path to store the consul-template configuration
- `extra_options` Default: ''. Extra options to be bassed to the consul-template agent. See https://github.com/hashicorp/consul-template#options
- `service_enable` Default: true.
- `service_ensure` Default: running.
- `user` Default: root. This used to be a default of `consul-template` and this caused much out-of-box pain for people.
- `group` Default: root.
- `manage_user` Default: false. Module handles creating the user.
- `manage_group` Default: false. Module handles creating the group.
- `init_style` Init style to use for consul-template service.
- `config_hash` Default: {}. Consul-template configuration options
- `config_defaults` Default: {}. Consul-template configuration option defaults.



##Usage

The simplest way to use this module is:
```puppet
include consul_template
```

Or to specify parameters:
```puppet
class { 'consul_template':
    service_enable   => false
    init_style       => 'upstart',
    config_hash      => {
      log_level => 'debug',
      wait      => '5s:30s',
      max_stale => '1s'
    }
}
```

## Watch files

To declare a file that you wish to populate from Consul key-values, you use the
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
      destination => '/tmp/common.json',
      command     => 'true',
    },
}
```

##Limitations

Depends on the JSON gem, or a modern ruby.

##Development
See the [contributing guide](CONTRIBUTING.md)

Open an [issue](https://github.com/gdhbashton/puppet-consul_template/issues) or
[fork](https://github.com/gdhbashton/puppet-consul_template/fork) and open a
[Pull Request](https://github.com/gdhbashton/puppet-consul_template/pulls)
