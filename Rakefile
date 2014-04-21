require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'
require 'rdoc/task'
require 'sodalogger'

# Used by rdoc tasks to add the README to the documentation.
def rdoc_actions(rdoc)
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end

# Used by grammar task to translate the token lines to YAML
def write_rules(file_name, out_file)
  out_file.write("\n:#{file_name[4..-5]}:\n")
  File.open(file_name, 'r').each_line do |line|
    line = line.split('::=').map { |item| item.strip }
    space = " " * (12 - line[0].size)
    out_file.write("  :#{line[0]}:#{space}!ruby/regexp   /^#{line[1]}$/\n")
  end
end

# Used by grammar task to process each line
def process_token_line(line, out_file, prev_name)
  name, rhs = line.split('::=').map { |item| item.strip }
  name, rhs = prev_name, line[2..-1] unless rhs
  return '' unless rhs
  out_file.write("  :#{name}:\n") if prev_name != name
  symbols, action = rhs.split(';')
  symbols.strip.split(' ').each_with_index do |symbol, index|
    out_file.write('    - - ') if index == 0
    out_file.write('      - ') if index != 0
    out_file.write(":#{symbol}\n")
  end
  action = '' if action.nil?
  out_file.write("      - #{action.strip}\n")
  name
end

# Run all tests
Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.libs << 'test'
end

# Generate public documentation
Rake::RDocTask.new do |rdoc|
  rdoc_actions(rdoc)
  rdoc.rdoc_dir = 'doc'
end

# Generate development documentation
Rake::RDocTask.new(:rdocdev) do |rdocdev|
  rdoc_actions(rdocdev)
  rdocdev.rdoc_dir = 'devdoc'
  rdocdev.options << '--all'
end

desc "Generates the grammar YAML file"
task :grammar do
  file_path = File.dirname(__FILE__)
  File.open('lib/src/grammar.yml', 'w') do |out_file|
    write_rules('src/tokens.txt', out_file)
    SodaLogger.success('Token rules created')

    write_rules('src/ignore.txt', out_file)
    SodaLogger.success('Ignore rules created')

    out_file.write("\n:grammar:\n")
    last_name = ''
    File.open('src/grammar.txt', 'r').each_line do |line|
      last_name = process_token_line(line, out_file, last_name)
    end
    SodaLogger.success('Grammar rules created')
  end
end

CLEAN.include('lib/src/grammar.yml')

task :default => :test
