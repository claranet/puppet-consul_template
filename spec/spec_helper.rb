require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.default_facts = {
    :architecture              => 'x86_64',
    :kernel                    => 'Linux',
    :operatingsystem           => 'Ubuntu',
    :operatingsystemmajrelease => '12.04',
    :osfamily                  => 'Debian',
    :path                      => '/bin:/sbin:/usr/bin:/usr/sbin',
    :staging_http_get          => 'curl',
  }
end
