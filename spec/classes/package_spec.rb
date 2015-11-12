require 'spec_helper'

describe 'consul_template::package' do
  let(:facts) {
    {
      :operatingsystem => "Ubuntu",
      :lsbdistcodename => "precise",
    }
  }

  let(:params) {
    {
      :ensure  => "present",
      :version => "0.11.0",
    }
  }

  it { should compile }

  it do
    should contain_apt__pin("consul-template").with({
      :ensure  => "present",
      :version => "0.11.0",
    })
  end

  it do
    should contain_package("consul-template").with({
      :ensure => "0.11.0",
    })
  end
end
