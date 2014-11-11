# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara-bootstrap-datepicker/version'

Gem::Specification.new do |gem|
  gem.name          = 'capybara-bootstrap-datepicker'
  gem.version       = Capybara::BootstrapDatepicker::VERSION
  gem.authors       = ['François Vantomme']
  gem.email         = ['akarzim@gmail.com']
  gem.description   = %q{Helper for triggering date input for bootstrap-datepicker javascript library}
  gem.homepage      = 'https://github.com/akarzim/capybara-bootstrap-datepicker'
  gem.summary       = gem.description
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rspec'
  gem.add_dependency 'capybara'
  gem.add_development_dependency 'phantomjs'
  gem.add_development_dependency 'poltergeist'
  gem.add_development_dependency 'pry'
end
