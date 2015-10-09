# == Class consul_template::intall
#
class consul_template::install {

  if ! empty($consul_template::data_dir) {
    file { $consul_template::data_dir:
      ensure => 'directory',
      owner  => $consul_template::manage_user,
      group  => $consul_template::manage_group,
      mode   => '0755',
    }
  }

  if $consul_template::install_method == 'url' {

    if $::operatingsystem != 'darwin' {
      ensure_packages(['tar'])
    }
    staging::file { "consul-template-${consul_template::version}.zip":
      source => $consul_template::download_url
    } ->
    staging::extract { "consul-template-${consul_template::version}.zip":
      target  => $consul_template::bin_dir,
      creates => "${consul_template::bin_dir}/consul-template-${consul_template::version}",
    } ->
    file {
        "${consul_template::bin_dir}/consul-template":
            ensure => link,
            target => "${consul_template::bin_dir}/consul-template$-{consul_template::version}";

        "${consul_template::bin_dir}/consul-template$-{consul_template::version}":
            owner => 'root',
            group => 0, # 0 instead of root because OS X uses "wheel".
            mode  => '0555';
    }

  } elsif $consul_template::install_method == 'package' {

    package { $consul_template::package_name:
      ensure => $consul_template::package_ensure,
    }

  } else {
    fail("The provided install method ${consul_template::install_method} is invalid")
  }

  if $consul_template::init_style {

    case $consul_template::init_style {
      'upstart' : {
        file { '/etc/init/consul-template.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('consul_template/consul-template.upstart.erb'),
        }
        file { '/etc/init.d/consul-template':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => root,
          group  => root,
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/consul-template.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('consul_template/consul-template.systemd.erb'),
        }
      }
      'sysv' : {
        file { '/etc/init.d/consul-template':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('consul_template/consul-template.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/consul-template':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('consul_template/consul-template.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/consul-template':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('consul_template/consul-template.sles.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${consul_template::init_style}")
      }
    }
  }

  if ! empty($consul_template::manage_user) {
    user { $consul_template::manage_user:
      ensure => 'present',
    }
  }
  if ! empty($consul_template::manage_group) {
    group { $consul_template::manage_group:
      ensure => 'present',
    }
  }
}
