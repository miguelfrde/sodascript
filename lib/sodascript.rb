require 'yaml'
require 'sodascript/lexer'
require 'sodascript/token'
require 'sodascript/rule'
require 'sodascript/grammar'
require 'sodascript/slritem'
require 'sodascript/slrtable'
require 'sodascript/slrparser'

##
# Main module of gem.
# It's used to compile a sodascript file to a javascript file.

module Sodascript

  DEFAULT_RULES_FILE = "#{File.dirname(__FILE__)}/src/grammar.yml"

  ##
  # Compiles the contents of the soda file and saves them to the js file.
  #
  # :args: soda_file, js_file

  def self.execute(*args)
    abort 'Wrong arguments, see help' unless args.size == 2
    @soda_file = args[0]
    @js_file = args[1]
    self.load_grammar
    self.compile
  end

  ##
  # Loads the grammar rules and token rules from a file

  def self.load_grammar(file = DEFAULT_RULES_FILE)
    data = eval YAML.load_file(file).inspect
    @token_rules = data[:tokens]
    @grammar_rules = data[:grammar]
  end

  private

  ##
  # Runs the compilation: lexical analysis, syntactic analysis,
  # semantic analysis, optimization and code generation.

  def self.compile
    tokens = self.lexical_analysis
    if ENV['SODA_DEBUG']
      puts 'Lexical analysis completed, tokens found:'
      tokens.each { |token| puts "    #{token}" }
    end

    # TODO: Syntactic analysis (parsing)

    # TODO: Semantic analysis

    # TODO: Optimization

    # TODO: Code generation
  end

  ##
  # Runs lexical analysis

  def self.lexical_analysis
    @lexer = Lexer.new
    @token_rules.each { |name, rule| @lexer.add_rule(name, rule) }
    @lexer.tokenize_file(@soda_file)
  end
end
