require 'spec_helper'


describe 'consul_template::watch' do
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
  context 'with a watch' do
    let(:title) { "my_watch" }

    let(:params) {
      {
        :source => "/tmp/template.ctmpl",
        :destination => "/tmp/template",
        :command => "update_vars",
        :perms => "0666"
      }
    }

    let(:config_file) { '/etc/consul-template/config.d/my_watch.hcl' }

    it do
      should contain_file(config_file).with({
        :ensure => 'present',
        :mode   => '0644',
        :owner  => 'root',
        :group  => 'consul-template'
      })
    end

    it { should contain_file(config_file).with_content(%r{source = "/tmp/template.ctmpl"}) }
    it { should contain_file(config_file).with_content(%r{destination = "/tmp/template"}) }
    it { should contain_file(config_file).with_content(%r{command = "update_vars"}) }
    it { should contain_file(config_file).with_content(%r{perms = 0666}) }

    describe "with no args" do
      let(:params) {{}}

      it {
        expect { should raise_error(Puppet::Error) }
      }
    end

    describe "with relative destination" do
      let(:params) {
        {
          :destination => "tmp"
        }
      }

      it {
        expect { should raise_error(Puppet::Error) }
      }
    end

    describe "with implicit destination" do
      let(:title) { "/tmp/template" }
      let(:params) {
        {
          :source => "/tmp/template.ctmpl",
        }
      }
      let(:config_file) { '/etc/consul-template/config.d/_tmp_template.hcl' }

      it { should contain_file(config_file).with_content(%r{source = "/tmp/template.ctmpl"}) }
      it { should contain_file(config_file).with_content(%r{destination = "/tmp/template"}) }
    end

    describe 'with content' do
      let(:title) { "my_watch" }
      let(:params) {
        {
          :content => "hello",
          :destination => "/tmp/template",
        }
      }
      let(:config_file) { '/etc/consul-template/config.d/my_watch.hcl' }
      let(:template_file) { '/etc/consul-template/template.d/my_watch.ctmpl' }

      it do
        should contain_file(template_file).with({
          :ensure  => 'present',
          :mode    => '0644',
          :owner   => 'root',
          :group   => 'consul-template',
          :content => 'hello'
        })
      end
  
      it { should contain_file(config_file).with_content(%r{source = "#{template_file}"}) }
    end
  end

end
