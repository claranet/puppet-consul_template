# == Class consul_template::intall
#
class consul_template::install {

  if $consul_template::data_dir {
    file { $consul_template::data_dir:
      ensure => 'directory',
      owner  => $consul_template::user,
      group  => $consul_template::group,
      mode   => '0755',
    }
  }

  if $consul_template::install_method == 'url' {

    if $::operatingsystem != 'darwin' {
      ensure_packages(['tar'])
    }
    staging::file { 'consul-template.tar.gz':
      source => $consul_template::download_url
    } ->
    staging::extract { 'consul-template.tar.gz':
      target  => $consul_template::bin_dir,
      creates => "${consul_template::bin_dir}/consul-template",
      strip   => 1,
    } ->
    file { "${consul_template::bin_dir}/consul-template":
      owner => 'root',
      group => 0, # 0 instead of root because OS X uses "wheel".
      mode  => '0555',
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
      'launchd' : {
        file { '/Library/LaunchDaemons/io.consul-template.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('consul_template/consul-template.launchd.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${consul_template::init_style}")
      }
    }
  }

  if $consul_template::manage_user {
    user { $consul_template::user:
      ensure => 'present',
    }
  }
  if $consul_template::manage_group {
    group { $consul_template::group:
      ensure => 'present',
    }
  }
}
