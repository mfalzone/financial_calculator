require 'rake'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

task default: :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = true
end