require 'spec_helper'


describe 'consul_template::watch', :type => :define do
  let(:pre_condition) { 'class { ::consul_template: }' }

  context 'supported operating systems' do
    rendered_content = <<-EOS

template {
  source = "/bar/source.ctmpl"
  destination = "/foo/destination.txt"
  command = "/bin/true"
}
EOS

    ['Debian', 'RedHat'].each do |osfamily|
      describe "consul_template::watch define on OS family #{osfamily}" do
        let(:title) { 'test_watcher' }
        let(:params) {{
          'destination' => '/foo/destination.txt',
          'source'      => '/bar/source.ctmpl',
          'command'     => '/bin/true',
        }}
        let(:facts) {{
          :osfamily       => osfamily,
        }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat__fragment(
          'consul-template/config.json+90-template-test_watcher').with_content(rendered_content) }

        it { is_expected.to_not contain_file('/etc/consul-template/test_watcher.ctmpl') }
      end
    end
  end
  context 'Setting template and template_vars' do
    rendered_content = <<-EOS

template {
  source = "/etc/consul-template/test_watcher.ctmpl"
  destination = "/foo/destination.txt"
  command = "/bin/true"
}
EOS
    templatedir = File.expand_path(File.join(__FILE__, '../..', 'fixtures', 'templates'))
    ['Debian', 'RedHat'].each do |osfamily|
      describe "consul_template::watch define on OS family #{osfamily}" do
        let(:title) { 'test_watcher' }
        let(:params) {{
          :destination   => '/foo/destination.txt',
          :command       => '/bin/true',
          :template      => "#{templatedir}/test_template.erb",
          :template_vars => {'foo' => 'bar'},
        }}
        let(:facts) {{
          :osfamily       => osfamily,
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/consul-template/test_watcher.ctmpl').with(
            :content => /^bar$/
        )}
        it { is_expected.to contain_concat__fragment(
          'consul-template/config.json+90-template-test_watcher').with_content(rendered_content) }
      end
    end
  end
end
