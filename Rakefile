require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'
require 'rdoc/task'

# Used by rdoc tasks to add the README to the documentation.
def rdoc_actions(rdoc)
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
end

# Used by grammar task to translate the token lines to YAML
def write_rules(file_name, out_file)
  out_file.write("\n:#{file_name[4..-5]}:\n")
  File.open(file_name, 'r').each_line do |line|
    line = line.split('::=').map { |item| item.strip }
    space = " " * (12 - line[0].size)
    out_file.write("  :#{line[0]}:#{space}!ruby/regexp   /^(#{line[1]})$/\n")
  end
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
    write_rules("src/tokens.txt", out_file)
    puts "Token rules created"

    write_rules("src/ignore.txt", out_file)
    puts "Ignore rules created"

    out_file.write("\n:grammar:\n")
    File.open("src/grammar.txt", 'r').each_line do |line|
      name, rhs = line.split('::=').map { |item| item.strip }
      next unless rhs
      out_file.write("  :#{name}:\n")
      rhs.split(" | ").each do |symbols|
        symbols.strip.split(' ').each_with_index do |symbol, index|
          out_file.write("    - - ") if index == 0
          out_file.write("      - ") if index != 0
          out_file.write(":#{symbol}\n")
        end
      end
    end
    puts "Grammar rules created"
  end
end

CLEAN.include('lib/src/grammar.yml')

task :default => :test
