require 'bundler'

Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

task :cleanup_rcov_files do
  rm_rf 'coverage'
end

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
end

namespace :spec do
  desc "Run all examples using rcov"
  RSpec::Core::RakeTask.new :rcov => :cleanup_rcov_files do |t|
    t.rspec_opts = %w[--color]
    t.rcov = true
    t.rcov_opts =  %[-Ilib -Ispec --exclude "gems/*,features"]
  end
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', 'webapp-rb Documentation']
end

