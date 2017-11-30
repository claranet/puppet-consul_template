require 'spec_helper'

describe 'consul_template', :type => :class do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts) do
          facts.merge({
            'staging_http_get' => 'curl',
            'concat_basedir'   => '/var/lib/puppet/concat'
          })
        end

        describe "consul_template class with no parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('consul_template::params') }
          it { is_expected.to contain_class('consul_template::install').that_comes_before('Class[consul_template::config]') }
          it { is_expected.to contain_class('consul_template::config') }
          it { is_expected.to contain_class('consul_template::service').that_subscribes_to('Class[consul_template::config]') }
          it { is_expected.to contain_service('consul-template') }
        end

        describe "Pin the version to an older release" do
          let(:params) {{
            'version' => '0.9.0',
          }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_staging__extract('consul-template_0.9.0.zip') }
        end

        describe 'consul_template::config' do
          context 'with defaults' do
            it { is_expected.to contain_concat('consul-template/config.json') }
          end

          context 'with config_hash' do
            let(:params) {{ config_hash: { 'log_level': 'foo' } }}
            it { is_expected.to contain_concat__fragment('consul-service-pre').with_content(/"log_level" *: *"foo"/) }
          end

          context 'with config_defaults' do
            let(:params) {{ config_defaults: { 'log_level': 'foo' } }}
            it { is_expected.to contain_concat__fragment('consul-service-pre').with_content(/"log_level" *: *"foo"/) }
          end

          context 'with config_defaults and config_hash' do
            let(:params) {{
              config_defaults: { 'log_level': 'foo' },
              config_hash: { 'log_level': 'bar' }
            }}

            it { is_expected.to contain_concat__fragment('consul-service-pre').with_content(/"log_level" *: *"bar"/) }
          end
        end


      end
    end
  end
end
