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
    data = YAML.load_file(file)
    @token_rules = data[:tokens]
    @ignore_rules = data[:ignore]
    grammar_rules = data[:grammar]
    @grammar = Grammar.new(:PROGRAM)

    grammar_rules.each do |lhs, prods|
      prods.each do |symbols|
        symbols.each_with_index do |sym, i|
          if sym == :br
            symbols[i] = Rule.new(sym, /^\n$/)
          elsif sym.to_s.downcase == sym.to_s and sym != Grammar::EPSILON
            symbols[i] = Rule.new(sym, @token_rules[sym])
          end
        end    
        @grammar.add_production(lhs, *symbols)
      end
    end

    if ENV['SODA_DEBUG']
      puts "Grammar loaded:"
      puts "    #{@grammar.to_s.split("\n").join("\n    ")}"
    end
  end

  private

  ##
  # Runs the compilation: lexical analysis, syntactic analysis,
  # semantic analysis, optimization and code generation.

  def self.compile
    self.lexical_analysis
    if ENV['SODA_DEBUG']
      puts "\nLexical analysis completed, tokens found:"
      @tokens.each { |token| puts "    #{token}" }
    end

    self.syntactic_analysis
    puts "\nParsing completed" if ENV['SODA_DEBUG']

    # TODO: Semantic analysis

    # TODO: Optimization

    # TODO: Code generation
  end

  ##
  # Runs lexical analysis

  def self.lexical_analysis
    @lexer = Lexer.new
    @token_rules.each { |name, rule| @lexer.add_rule(name, rule) }
    @ignore_rules.each { |name, rule| @lexer.ignore(name, rule) }
    @tokens = @lexer.tokenize_file(@soda_file)
  end

  ##
  # Runs syntactic analysis

  def self.syntactic_analysis
    @parser = SLRParser.new(@grammar)
    @parser.parse(@tokens)
  end
end
