require 'spec_helper'

describe 'consul_template' do
  let(:facts) {
    {
      :operatingsystem => 'Ubuntu',
      :lsbdistcodename => 'precise',
    }
  }

  let(:params) {
    {
      :ensure  => 'present',
      :version => '0.11.0',
      :status  => 'enabled',
    }
  }

  it { should compile }

  it do
    should contain_class("consul_template::config").with({
      :ensure => "present",
    })

    should contain_class("consul_template::package").with({
      :ensure => "present",
      :version => "0.11.0",
    })

    should contain_class("consul_template::service").with({
      :ensure => "present",
      :status => "enabled"
    })
  end

  context "absent" do
    let(:params) {
      {
        :ensure => 'absent',
      }
    }

    it { should contain_class("consul_template::config").with_ensure("absent") }
    it { should contain_class("consul_template::package").with_ensure("absent") }
    it { should contain_class("consul_template::service").with_ensure("absent") }
  end
end
