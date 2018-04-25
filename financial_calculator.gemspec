lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'financial_calculator/version'

SPEC = Gem::Specification.new do |s|
  s.name = "financial_calculator"
  s.version = FinancialCalculator::VERSION
  s.author = "Mike Falzone"
  s.license = "LGPL-3.0"
  s.email = "michael.falzone@gmail.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "A library for financial modelling in Ruby."
  s.description = "The financial calculator library provides a Ruby interface for performing common financial calculations (NPV, IRR, etc.)."
  s.homepage = "https://rubygems.org/gems/financial_calculator"

  s.required_ruby_version = '>=2.2.2'

  s.add_dependency 'flt', '>=1.5.0'

  s.add_development_dependency 'activesupport', '>= 5.0.0'
  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'coveralls_reborn', '>= 0.11.1'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.4.0'
  s.add_development_dependency 'simplecov', '>= 0.16.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md', 'COPYING', 'COPYING.LESSER', 'HISTORY']
end