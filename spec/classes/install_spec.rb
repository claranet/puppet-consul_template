require 'spec_helper'

describe 'consul_template::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          'staging_http_get' => 'curl',
          'concat_basedir'   => '/var/lib/puppet/concat',
        )
      end

      context 'with all defaults' do
        let(:pre_condition) { 'include consul_template' }

        it { is_expected.to compile }
      end

      context 'when disabling management of init files' do
        let(:pre_condition) do
          "
          class { 'consul_template':
            init_style => 'unmanaged',
          }
          "
        end

        it { is_expected.not_to contain_file('/etc/init.d/consul-template') }
        it { is_expected.not_to contain_file('/lib/systemd/system/consul-template.service') }
      end
    end
  end
end
