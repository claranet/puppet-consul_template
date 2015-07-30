require 'spec_helper'


describe 'consul_template::watch', :type => :define do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "consul_template::watch define on OS family #{osfamily}" do
        let(:title) { 'test_watcher' }
        let(:params) {{
          :destination => '/var/tmp/consul_template',
          :command => '/bin/test',
        }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin',
          :architecture   => 'x86_64'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('consul_template') }
        it { is_expected.to contain_concat__fragment('test_watcher.ctmpl') }

      end
    end
  end
  context 'Setting template and template_vars' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "consul_template::watch define on OS family #{osfamily}" do
        let(:title) { 'test_watcher' }
        let(:params) {{
          :template => 'consul_template_spec/test_template',
          :template_vars => { 'foo' => 'bar' },
          :destination => '/var/tmp/consul_template',
          :command => '/bin/test',
        }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin',
          :architecture   => 'x86_64'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/consul-template/test_watcher.ctmpl').with(
            :content => /^bar$/,
        )}
        it { is_expected.to contain_concat__fragment('test_watcher.ctmpl') }

      end
    end
  end

end
