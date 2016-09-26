require 'spec_helper'

describe 'consul_template', :type => :class do
  context 'On an unsupported arch' do
    let(:facts) {{ :architecture => 'foo' }}
    it do
      expect { is_expected.to compile }.to raise_error(/Unsupported kernel architecture:/)
    end
  end

  context 'When not specifying whether to purge config' do
    it { is_expected.to contain_file('/etc/consul-template').with(:purge => true, :recurse => true) }
    it { is_expected.to contain_file('/etc/consul-template/config').with(:purge => true, :recurse => true) }
  end

  context 'When passing a non-bool to parameter' do
    [:auth_enabled,
     :deduplicate_enabled,
     :logrotate_on,
     :manage_group,
     :manage_user,
     :purge_config_dir,
     :ssl_enabled,
     :ssl_verify,
     :syslog_enabled,
     :vault_renew_token,
     :vault_ssl_enabled,
     :vault_ssl_verify,
     :vault_unwrap_token,
     :deduplicate,  # deprecated
     :vault_ssl,  # deprecated
    ].each do |param|
      let(:params) {{
        param => 'foo',
      }}
      it "'#{param}' validation should raise an error" do
        expect { is_expected.to compile }.to raise_error(/is not a boolean/)
      end
    end
  end

  context 'When passing a non-hash to parameter' do
    [:watches].each do |param|
      let(:params) {{
        param => false,
      }}
      it "'#{param}' validation should raise an error" do
        expect { is_expected.to compile }.to raise_error(/is not a Hash/)
      end
    end
  end

  context "When installing via URL by default" do
    it { is_expected.to contain_staging__file('consul-template_0.11.0.zip').with(:source => 'https://releases.hashicorp.com/consul-template/0.11.0/consul-template_0.11.0_linux_amd64.zip') }
    it { is_expected.to contain_staging__extract('consul-template_0.11.0.zip') }
    it { is_expected.to contain_file('/usr/local/bin/consul-template') }
  end

  context "When installing via URL by with a custom version" do
    let(:params) {{
      :version   => '0.9.0',
    }}
    it { is_expected.to contain_staging__file('consul-template_0.9.0.zip').with(:source => 'https://releases.hashicorp.com/consul-template/0.9.0/consul-template_0.9.0_linux_amd64.zip') }
    it { is_expected.to contain_staging__extract('consul-template_0.9.0.zip') }
    it { is_expected.to contain_file('/usr/local/bin/consul-template') }
  end

  context "When installing via URL by with a custom url" do
    let(:params) {{
      :download_url   => 'http://myurl',
    }}
    it { is_expected.to contain_staging__file('consul-template_0.11.0.zip').with(:source => 'http://myurl') }
    it { is_expected.to contain_file('/usr/local/bin/consul-template') }
  end

  context 'When requesting to install via a custom package and version' do
    let(:params) {{
      :install_method => 'package',
      :package_ensure => 'specific_release',
      :package_name   => 'custom_consul-template_package'
    }}
    it { is_expected.to contain_package('custom_consul-template_package').with(:ensure => 'specific_release') }
  end

  context "When the user provides a hash of watches" do
    let(:params) {{
      :watches => {
        'test_watch1' => {
           'command'     => '/bin/true',
           'destination' => '/tmp/foo',
        }
      }
    }}
    it { is_expected.to contain_consul_template__watch('test_watch1').with_command('/bin/true') }
    it { is_expected.to contain_consul_template__watch('test_watch1').with_destination('/tmp/foo') }
    it { is_expected.to have_consul_template__watch_resource_count(1) }
    it { is_expected.to contain_concat__fragment('test_watch1.ctmpl').with_content(/source = "\/etc\/consul-template\/test_watch1.ctmpl"/).that_notifies(['Service[consul-template]'])  }
  end

  context "When auth is enabled" do
    let(:params) {{
      :auth_enabled  => true,
      :auth_username => 'foo',
      :auth_password => 'bar',
    }}
    it { is_expected.to contain_concat__fragment('consul-template/config.json+10-auth').with(
      :content => /^auth \{\n  enabled\s+= true\n\n  password\s+= "bar"\n  username\s+= "foo"\n\}/,
      :target  => 'consul-template/config.json'
    )}
  end

  context "When auth is disabled" do
    [false, :undef].each do |auth_enabled|
      let(:params) {{
        :auth_enabled  => auth_enabled,
        :auth_username => 'foo',
        :auth_password => 'bar',
      }}
      it { is_expected.to_not contain_concat__fragment('consul-template/config.json+10-auth') }
    end
  end

  context "When deduplicate is enabled" do
    let(:params) {{
      :deduplicate_enabled => true,
      :deduplicate_prefix  => '/foo/bar',
    }}
    it { is_expected.to contain_concat__fragment('consul-template/config.json+20-deduplicate').with(
      :content => /^deduplicate \{\n  enabled\s+= true\n\n  prefix\s+= "\/foo\/bar"\n\}/,
      :target  => 'consul-template/config.json'
    )}
  end

  context "When deduplicate is disabled" do
    [false, :undef].each do |deduplicate_enabled|
      let(:params) {{
        :deduplicate_enabled => deduplicate_enabled,
        :deduplicate_prefix  => '/foo/bar',
      }}
      it { is_expected.to_not contain_concat__fragment('consul-template/config.json+20-deduplicate') }
    end
  end

  context "When exec command is set" do
    let(:params) {{
      :exec_command       => '/bin/true',
      :exec_kill_signal   => 'SIGFOO',
      :exec_kill_timeout  => '5s',
      :exec_reload_signal => 'SIGBAR',
      :exec_splay         => '10s',
    }}
    it { is_expected.to contain_concat__fragment('consul-template/config.json+30-exec').with(
      :content => /^exec \{\n  command\s+= "\/bin\/true"\n  kill_signal\s+= "SIGFOO"\n  kill_timeout\s+= "5s"\n  reload_signal\s+= "SIGBAR"\n  splay\s+= "10s"\n\}/,
      :target  => 'consul-template/config.json'
    )}
  end

  context "When exec command is not set" do
    [false, :undef].each do |exec_command|
      let(:params) {{
        :exec_command       => exec_command,
        :exec_kill_signal   => 'SIGFOO',
        :exec_kill_timeout  => '5s',
        :exec_reload_signal => 'SIGBAR',
        :exec_splay         => '10s',
      }}
      it { is_expected.to_not contain_concat__fragment('consul-template/config.json+30-exec') }
    end
  end

  context "When ssl is enabled" do
    let(:params) {{
      :ssl_enabled => true,
      :ssl_verify  => true,
      :ssl_cert    => '/foo.crt',
      :ssl_key     => '/foo.key',
      :ssl_ca_cert => '/foo.ca',
    }}
    it { is_expected.to contain_concat__fragment('consul-template/config.json+40-ssl').with(
      :content => /^ssl \{\n  enabled\s+= true\n\n  ca_cert\s+= "\/foo\.ca"\n  cert\s+= "\/foo\.crt"\n  key\s+= "\/foo\.key"\n  verify\s+= true\n\}/,
      :target  => 'consul-template/config.json'
    )}
  end

  context "When syslog is enabled" do
    let(:params) {{
      :syslog_enabled  => true,
      :syslog_facility => 'FOO5',
    }}
    it { is_expected.to contain_concat__fragment('consul-template/config.json+50-syslog').with(
      :content => /^syslog \{\n  enabled\s+= true\n\n  facility\s+= "FOO5"\n\}/,
      :target  => 'consul-template/config.json'
    )}
  end

  context "When syslog is disabled" do
    [false, :undef].each do |syslog_enabled|
      let(:params) {{
        :syslog_enabled => syslog_enabled,
      }}
      it { is_expected.not_to contain_concat__fragment('consul-template/config.json+50-syslog') }
    end
  end

  context "When vault is enabled without ssl" do
    [false, :undef].each do |vault_ssl_enabled|
      let(:params) {{
        :vault_address      => 'foo.bar.com:8200',
        :vault_enabled      => true,
        :vault_renew_token  => true,
        :vault_ssl_enabled  => vault_ssl_enabled,
        :vault_token        => '1234567890abcdef',
        :vault_unwrap_token => false,
      }}
      it { is_expected.to contain_concat__fragment('consul-template/config.json+60-vault').with(
        :content => /^vault \{\n  address\s+= "foo.bar.com:8200"\n  renew_token\s+= true\n  token\s+= "1234567890abcdef"\n  unwrap_token\s+= false\n\}/,
        :target  => 'consul-template/config.json'
      )}
    end
  end

  context "When vault is enabled with ssl" do
    let(:params) {{
      :vault_address      => 'foo.bar.com:8200',
      :vault_enabled      => true,
      :vault_renew_token  => true,
      :vault_ssl_enabled  => true,
      :vault_ssl_cert     => '/foo.crt',
      :vault_ssl_key      => '/foo.key',
      :vault_ssl_ca_cert  => '/foo.ca',
      :vault_ssl_verify   => true,
      :vault_token        => '1234567890abcdef',
      :vault_unwrap_token => false,
    }}
    it { is_expected.to contain_concat__fragment('consul-template/config.json+60-vault').with(
      :content => /^vault \{\n  address\s+= "foo.bar.com:8200"\n  renew_token\s+= true\n  token\s+= "1234567890abcdef"\n  unwrap_token\s+= false\n\n  ssl \{\n    enabled\s+= true\n\n    ca_cert\s+= "\/foo\.ca"\n    cert\s+= "\/foo\.crt"\n    key\s+= "\/foo\.key"\n    verify\s+= true\n  \}\n\}/,
      :target  => 'consul-template/config.json'
    )}
  end

  context "When vault is disabled" do
    [false, :undef].each do |vault_enabled|
      let(:params) {{
        :vault_enabled => vault_enabled,
      }}
      it { is_expected.not_to contain_concat__fragment('consul-template/config.json+60-vault') }
    end
  end

  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "consul_template class with no parameters on OS family #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('consul_template::params') }
        it { is_expected.to contain_class('consul_template::validate_params') }
        it { is_expected.to contain_class('consul_template::install').that_comes_before('Class[consul_template::config]') }
        it { is_expected.to contain_class('consul_template::config') }
        it { is_expected.to contain_class('consul_template::service').that_subscribes_to('Class[consul_template::config]') }

        it { is_expected.to contain_file('/etc/init.d/consul-template') }
        it { is_expected.to contain_file('/etc/init/consul-template.conf') }

        it { is_expected.to contain_service('consul-template') }

        it { is_expected.to contain_concat('consul-template/config.json').with_path('/etc/consul-template/config/config.json').that_notifies('Service[consul-template]') }
        it { is_expected.to contain_concat__fragment('consul-template/config.json+00-main').with(
          :content => /^consul\s+= "localhost:8500"\n/,
          :target  => 'consul-template/config.json'
        )}
      end

      describe "Pin the version to an older release" do
        let(:params) {{
          'version' => '0.9.0',
        }}
        let(:facts) {{
          :osfamily       => osfamily,
        }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_staging__extract('consul-template_0.9.0.zip') }

      end
    end
  end
end
