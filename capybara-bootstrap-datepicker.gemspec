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
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.5.7'

  gem.metadata['rubygems_mfa_required'] = 'true'
end
