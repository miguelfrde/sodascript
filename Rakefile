require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.libs << 'test'
end

task :default => :test
