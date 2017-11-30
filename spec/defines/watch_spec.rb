require 'spec_helper'


describe 'consul_template::watch', :type => :define do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :staging_http_get => 'curl',
          })
        end

        describe "consul_template::watch define on OS family #{os}" do
          let(:title) { 'test_watcher' }
          let(:params) {{
            :template    => 'consul_template_spec/test_template',
            :config_hash => {
              'destination' => '/var/tmp/consul_template',
              'command'     => '/bin/test',
            }
          }}

          facts.merge({
            :concat_basedir   => '/foo',
            :path             => '/bin:/sbin:/usr/bin:/usr/sbin',
            :staging_http_get => 'curl',
          })

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('consul_template') }
          it {
            skip "can't realize virtual concat::fragment"
            is_expected.to contain_concat__fragment('test_watcher.ctmpl')
          }
        end
      end
    end
  end
end
