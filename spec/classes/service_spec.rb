require 'spec_helper'

describe 'consul_template::service' do
  let(:facts) {
    {
      :operatingsystem => "Ubuntu",
      :lsbdistcodename => "precise",
      :processorcount  => "2",
    }
  }

  let(:params) {
    {
      :ensure => 'present',
    }
  }

  let(:upstart_file) { '/etc/init/consul-template.conf' }

  it { should compile }

  it do
    should contain_file(upstart_file).with({
      :ensure => 'present',
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root'
    })
  end

  it { should contain_file(upstart_file).with_content(/setuid consul-template/) }
  it { should contain_file(upstart_file).with_content(/setgid consul-template/) }
  it { should contain_file(upstart_file).with_content(%r(CONFIG=/etc/consul-template/config.d)) }
  it { should contain_file(upstart_file).with_content(%r(GOMAXPROCS=2)) }

  it do
    should contain_service("consul_template").with({
      :ensure   => 'running',
      :enable   => true,
      :provider => 'upstart',
    })
  end

  context "ensure absent" do
    let(:params) {
      {
        :ensure => 'absent'
      }
    }

    it do
      should contain_service("consul_template").with({
        :ensure => 'stopped',
        :enable => false
      })
    end
  end

  context "ensure running" do
    let(:params) {
      {
        :ensure => 'present',
        :status => 'running'
      }
    }

    it do
      should contain_service("consul_template").with({
        :ensure => 'running',
        :enable => false
      })
    end
  end


  context "unmanaged service" do
    let(:params) {
      {
        :ensure => 'present',
        :status => 'unmanaged',
      }
    }

    it do
      should contain_service("consul_template").with({
        :ensure => nil,
        :enable => false
      })
    end
  end

  context "bad status" do
    let(:params) {
      {
        :ensure => 'present',
        :status => 'whatever',
      }
    }

    it do
      expect { should contain_service("consul_template") }.to raise_error Puppet::Error,
        /consul_template::service: status was an unexpected value: whatever/
    end
  end

end
