require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

def rdoc_actions(rdoc)
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
end

Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.libs << 'test'
end

Rake::RDocTask.new do |rdoc|
  rdoc_actions(rdoc)
  rdoc.rdoc_dir = "doc"
end

Rake::RDocTask.new(:rdocdev) do |rdocdev|
  rdoc_actions(rdocdev)
  rdocdev.rdoc_dir = "devdoc"
  rdocdev.options << "--all"
end

task :default => :test
