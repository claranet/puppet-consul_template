source "https://rubygems.org"

group :test do
  # Pin for 1.8.7 compatibility
  gem "json", '~> 1.8.3'
  gem "json_pure", '~> 1.8.3'
  gem "rake", '< 11.0.0'
  gem "rspec", '< 3.2.0'
  gem "rspec-core", "3.1.7"
  gem "rspec-puppet", "~> 2.1"

  gem "hiera"
  gem "hiera-puppet-helper"
  gem "puppet-lint"
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper"
  gem 'metadata-json-lint'
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end

group :system_tests do
  gem "beaker"
end

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet'
end
