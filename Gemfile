source "https://rubygems.org"

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.8.7'
  gem 'safe_yaml', '~> 1.0.4'
  gem 'puppet-lint'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'rspec-puppet-facts'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper', '< 2.0.0'
  gem 'metadata-json-lint', '1.1.0'
  gem 'json', '< 2.0.0'
  gem 'xmlrpc', :require => false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.4.0')
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'vagrant-wrapper'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
end

group :system_tests do
  gem 'beaker'
end
