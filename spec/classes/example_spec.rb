require 'spec_helper'

describe 'consul_template' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "consul_template class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('consul_template::params') }
        it { is_expected.to contain_class('consul_template::install').that_comes_before('consul_template::config') }
        it { is_expected.to contain_class('consul_template::config') }
        it { is_expected.to contain_class('consul_template::service').that_subscribes_to('consul_template::config') }

        it { is_expected.to contain_service('consul-template') }
      end
    end
  end
end
