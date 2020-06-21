# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'English'
require 'capybara-bootstrap-datepicker/version'

Gem::Specification.new do |gem|
  gem.name          = 'capybara-bootstrap-datepicker'
  gem.version       = Capybara::BootstrapDatepicker::VERSION
  gem.authors       = ['François Vantomme']
  gem.email         = ['akarzim@pm.me']
  gem.summary       = 'Bootstrap datepicker helper for Capybara'
  gem.description   = 'Helper for triggering date input for bootstrap-datepicker javascript library'
  gem.homepage      = 'https://github.com/akarzim/capybara-bootstrap-datepicker'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($RS)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.5.7'

  gem.add_development_dependency 'capybara', '~> 3.29', '>= 3.29.0'
  gem.add_development_dependency 'capybara-screenshot', '~> 1.0', '>= 1.0.22'
  gem.add_development_dependency 'phantomjs', '~> 2.1', '>= 2.1.1.0'
  gem.add_development_dependency 'poltergeist', '~> 1.18', '>= 1.18.1'
  gem.add_development_dependency 'rspec', '~> 3.9', '>= 3.9.0'
end
