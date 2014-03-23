require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

# Used by rdoc tasks to add the README to the documentation.
def rdoc_actions(rdoc)
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
end

# Used by grammar task to translate the token lines to YAML
def line_to_yml(line, out_file)
  line = line.split('::=').map { |item| item.strip }
  space = " " * (12 - line[0].size)
  out_file.write("  :#{line[0]}:#{space}!ruby/regexp   /^(#{line[1]})$/\n")
end

# Run all tests
Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.libs << 'test'
end

# Generate public documentation
Rake::RDocTask.new do |rdoc|
  rdoc_actions(rdoc)
  rdoc.rdoc_dir = "doc"
end

# Generate development documentation
Rake::RDocTask.new(:rdocdev) do |rdocdev|
  rdoc_actions(rdocdev)
  rdocdev.rdoc_dir = "devdoc"
  rdocdev.options << "--all"
end

desc "Generates the grammar YAML file"
task :grammar do
  file_path = File.dirname(__FILE__)
  File.open("lib/src/grammar.yml", 'w') do |out_file|
    out_file.write(":tokens:\n")
    File.open("src/tokens.txt", 'r').each_line do |s|
      line_to_yml(s, out_file)
    end
    puts "Token rules created"

    out_file.write("\n:ignore:\n")
    File.open("src/ignore.txt", 'r').each_line do |s|
      line_to_yml(s, out_file)
    end
    puts "Ignore rules created"

    # TODO: Read and write grammar
  end

end

task :default => :test
