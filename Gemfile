source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem 'rake',                                                       :require => false
  gem 'puppet-lint',                                                :require => false
  gem 'puppet-lint-absolute_classname-check',                       :require => false
  gem 'puppet-lint-alias-check',                                    :require => false
  gem 'puppet-lint-package_ensure-check',                           :require => false
  gem 'puppet-lint-legacy_facts-check',                             :require => false
  gem 'puppet-lint-leading_zero-check',                             :require => false
  gem 'puppet-lint-global_resource-check',                          :require => false
  gem 'puppet-lint-file_source_rights-check',                       :require => false
  gem 'puppet-lint-file_ensure-check',                              :require => false
  gem 'puppet-lint-empty_string-check',                             :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',  :require => false
  gem 'rspec-puppet-facts',                                         :require => false
  gem 'rspec-puppet-utils',                                         :require => false
  gem 'puppet-syntax',                                              :require => false
  gem 'safe_yaml', '~> 1.0.4',                                      :require => false
  gem 'rspec-puppet', '~> 2.5',                                     :require => false
  gem 'metadata-json-lint',                                         :require => false
  gem 'xmlrpc',                                                     :require => false
  gem 'json', '< 2.0.0',                                            :require => false
end
group :development do
  gem 'travis',             :require => false
  gem 'travis-lint',        :require => false
  gem 'vagrant-wrapper',    :require => false
  gem 'puppet-blacksmith',  :require => false
  gem 'guard-rake',         :require => false
end
group :system_tests do
  gem 'beaker',  :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion.to_s, :require => false, :groups => [:test]
else
gem 'facter', :require => false, :groups => [:test]
end

ENV['PUPPET_VERSION'].nil? ? puppetversion = '~> 5.0' : puppetversion = ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, :require => false, :groups => [:test]
