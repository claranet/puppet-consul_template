Vagrant.require_version ">= 1.6.5"

# ===========================
# VARIABLES + BOX DEFINITIONS
# ===========================

SSH_BASE_PORT  = 2600
WEB_BASE_PORT  = 8500
PUPPET_VERSION = "4.10.9"
DEFAULT_TEST   = "init"

BOXES = [
  { name: "debian7",  box: "debian/wheezy64", version: "7.11.2" },
  { name: "debian8",  box: "debian/jessie64", version: "8.9.0" },
  { name: "ubuntu14", box: "ubuntu/trusty64", version: "20170810.0.0" },
  { name: "ubuntu16", box: "ubuntu/xenial64", version: "20170811.0.0" },
  { name: "centos6",  box: "centos/6", version: "1707.01" },
  { name: "centos7",  box: "centos/7", version: "1707.01" }
]

MODULES = [
  # Module dependencies
  { name: "puppetlabs-concat", version: "2.2.1" },
  { name: "puppetlabs-stdlib" },
  { name: "puppet-staging", version: "3.0.0" },
  { name: "KyleAnderson-consul", version: "3.2.3" },
  # Test depdendencies
  { name: "puppet-nginx", git: "https://github.com/voxpupuli/puppet-nginx.git" }
]

# ==============
# VAGRANT CONFIG
# ==============

unless Vagrant.has_plugin?("vagrant-puppet-install")
  raise 'vagrant-puppet-install is not installed!'
end

Vagrant.configure("2") do |config|

  # = Actually do some work
  BOXES.each_with_index do |definition,idx|

    name = definition[:name]
    ip = 254 - idx

    # == Allow passing a Puppet version via environment variable
    if ENV['PUPPET_VERSION'].nil?
      config.puppet_install.puppet_version = PUPPET_VERSION
    else
      config.puppet_install.puppet_version = ENV['PUPPET_VERSION']
    end

    # Handle Puppet 3 and 4/5 paths
    if PUPPET_VERSION.start_with?('3')
      puppet_bin_path = '/usr/bin/puppet'
      module_path = '/etc/puppet/modules'
    else
      puppet_bin_path = '/opt/puppetlabs/bin/puppet'
      module_path = '/etc/puppetlabs/code/environments/production/modules'
    end


    config.vm.define name, autostart: false do |c|

      # == Basic box setup
      c.vm.box         = definition[:box]
      c.vm.box_version = definition[:version] unless definition[:version].nil?
      c.vm.hostname    = "vagrant-consul-template-#{name}"
      c.vm.network :private_network, ip: "10.0.255.#{ip}"

      # == Shared folder
      if Vagrant::Util::Platform.darwin?
        config.vm.synced_folder ".", "/vagrant", nfs: true
        c.nfs.map_uid = Process.uid
        c.nfs.map_gid = Process.gid
      else
        c.vm.synced_folder ".", "/vagrant", type: "nfs"
      end

      # == Disable vagrant's default SSH port, then configure our override
      new_ssh_port = SSH_BASE_PORT + idx
      c.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: "true"
      c.ssh.port = new_ssh_port
      c.vm.network :forwarded_port, guest: 22, host: new_ssh_port

      # == Add port forwarding for Consul Web UI
      web_port = WEB_BASE_PORT + idx
      c.vm.network :forwarded_port, guest: 8500, host: web_port

      # == Set resources if configured
      c.vm.provider "virtualbox" do |v|
        v.name = "puppet_consul-template-#{name}"
        v.memory = definition[:memory] unless definition[:memory].nil?
        v.cpus = definition[:cpus] unless definition[:cpus].nil?
      end

      # == Allow passing a test file
      if ENV['TEST_FILE'].nil?
        test_file = DEFAULT_TEST
      else
        test_file = ENV['TEST_FILE']
      end

      # == Install git ... with Puppet!
      c.vm.provision :shell, :inline => "#{puppet_bin_path} resource package git ensure=present"

      # == Install modules
      MODULES.each do |mod|
        if mod[:git].nil?
          if mod[:version].nil?
            mod_version = ''
          else
            mod_version = " --version #{mod[:version]}"
          end
          c.vm.provision :shell, :inline => "#{puppet_bin_path} module install #{mod[:name]}#{mod_version}"
        else
          mod_name = mod[:name].split('-').last
          c.vm.provision :shell, :inline => "if [ ! -d #{module_path}/#{mod_name} ]; then git clone #{mod[:git]} #{module_path}/#{mod_name}; fi"
        end
      end
      c.vm.provision :shell, :inline => "if [ ! -L #{module_path}/consul_template ]; then ln -s /vagrant #{module_path}/consul_template; fi"

      # == Finally, run Puppet!
      c.vm.provision :shell, :inline => "STDLIB_LOG_DEPRECATIONS=false #{puppet_bin_path} apply --verbose --show_diff /vagrant/examples/#{test_file}.pp"

      c.vm.provision :shell, :inline => "echo 'Consul Web UI: http://localhost:#{web_port}'"
    end
  end
end
