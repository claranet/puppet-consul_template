require 'spec_helper'

describe 'consul_template', :type => :class do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "consul_template class with no parameters on OS family #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin',
          :architecture   => 'x86_64'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('consul_template::params') }
        it { is_expected.to contain_class('consul_template::install').that_comes_before('consul_template::config') }
        it { is_expected.to contain_class('consul_template::config') }
        it { is_expected.to contain_class('consul_template::service').that_subscribes_to('consul_template::config') }

        it { is_expected.to contain_service('consul-template') }
      end
      describe "Pin the version to an older release" do
        let(:params) {{
          'version' => '0.9.0',
        }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin',
          :architecture   => 'x86_64'
        }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_staging__extract('consul-template_0.9.0.zip') }

      end
    end
  end
end
