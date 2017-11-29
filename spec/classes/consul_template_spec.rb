require 'spec_helper'

describe 'consul_template', :type => :class do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts) do
          facts.merge({
            'kernel'           => 'Linux',
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
          let(:params) {{ consul_token: 'fe3b8d40-0ee0-8783-6cc2-ab1aa9bb16c1' }}

          context 'with defaults' do
            it do
              is_expected.to contain_concat__fragment('consul_template.config.header').
                with_content(%r{consul = "localhost:8500"}).
                with_content(%r{token = "fe3b8d40-0ee0-8783-6cc2-ab1aa9bb16c1"})
            end
            it { is_expected.not_to contain_concat__fragment('consul-ssl-base') }
          end
        end
      end
    end
  end
end
