require 'spec_helper'


describe 'consul_template::watch', :type => :define do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :kernel => 'Linux',
            :staging_http_get => 'curl'
          })
        end

        describe "consul_template::watch define" do
          let(:title) { 'test_watcher' }
          let(:params) {{
            :destination => '/var/tmp/consul_template',
            :command => '/bin/test',
          }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('consul_template') }
          it { is_expected.to contain_concat__fragment('test_watcher.ctmpl') }

        end

        describe "consul_template::watch define with template" do
          let(:title) { 'test_watcher' }
          let(:params) {{
            :template => 'consul_template_spec/test_template',
            :template_vars => { 'foo' => 'bar' },
            :destination => '/var/tmp/consul_template',
            :command => '/bin/test',
          }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/etc/consul-template/test_watcher.ctmpl').with(
              :content => /^bar$/,
          )}
          it { is_expected.to contain_concat__fragment('test_watcher.ctmpl') }
        end

        describe "consul_template::watch define with content" do
          let(:title) { 'test_watcher' }
          let(:params) {{
            :content => 'foobar',
            :destination => '/var/tmp/consul_template',
            :command => '/bin/test',
          }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_file('/etc/consul-template/test_watcher.ctmpl').with(
            :content => /^foobar$/,
          )}
          it { is_expected.to contain_concat__fragment('test_watcher.ctmpl') }
        end

      end
    end
  end
end
