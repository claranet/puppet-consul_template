#consul_template for Puppet

##Installation

###What This Module Affects

* Installs the consul-template binary (via url or package)
* Optionally installs a user to run it under
* Installs a configuration file (/etc/consul-template/config.json)
* Manages the consul-template service via upstart, sysv, or systemd

##Usage

```puppet
include consul_template
```

## Watch files

To declare a file that you wish to populate from Consul key-values, you use the
`watch` define. This requires a source `.ctmpl` file and the file on-disk
that you want to update.

```puppet
consul_template::watch { 'common':
    template    => 'data/common.json.ctmpl.erb',
    destination => '/tmp/common.json',
    command     => 'true',
}
```

##Limitations

Depends on the JSON gem, or a modern ruby.

##Thanks
To solarkennedy whose consul module I shamelessly based this one on.

##Development
Open an [issue](https://github.com/gdhbashton/puppet-consul_template/issues) or 
[fork](https://github.com/gdhbashton/puppet-consul_template/fork) and open a 
[Pull Request](https://github.com/gdhbashton/puppet-consul_template/pulls)
