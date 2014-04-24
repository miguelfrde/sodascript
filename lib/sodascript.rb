require 'yaml'
require 'sodalogger'
require 'sodascript/lexer'
require 'sodascript/token'
require 'sodascript/rule'
require 'sodascript/grammar'
require 'sodascript/slritem'
require 'sodascript/slrtable'
require 'sodascript/slrparser'
require 'sodascript/llparser'
require 'sodascript/semantic/assign'
require 'sodascript/semantic/attribute_accessor'
require 'sodascript/semantic/case'
require 'sodascript/semantic/class'
require 'sodascript/semantic/elsif'
require 'sodascript/semantic/expression'
require 'sodascript/semantic/for'
require 'sodascript/semantic/function'
require 'sodascript/semantic/if'
require 'sodascript/semantic/inline_condition'
require 'sodascript/semantic/print'
require 'sodascript/semantic/range'
require 'sodascript/semantic/return'
require 'sodascript/semantic/loop_control'
require 'sodascript/semantic/unless'
require 'sodascript/semantic/variable'
require 'sodascript/semantic/when'
require 'sodascript/semantic/while'

##
# Main module of gem.
# It's used to compile a sodascript file to a javascript file.

module Sodascript

  # YAML file where the token rules and grammar rules are defined.
  DEFAULT_RULES_FILE = "#{File.dirname(__FILE__)}/src/grammar.yml"

  ##
  # Compiles the contents of the soda file and saves them to the js file.
  #
  # :args: soda_file, js_file

  def self.execute(*args)
    abort 'Wrong arguments, see help' unless args.size == 2
    @soda_file = args[0]
    @js_file = args[1]
    @grammar_file = ENV['GRAMMAR_FILE'] || DEFAULT_RULES_FILE
    self.load_grammar
    self.compile
  end

  ##
  # Loads the grammar rules and token rules from a file

  def self.load_grammar(file = DEFAULT_RULES_FILE)
    data = YAML.load_file(@grammar_file)
    @token_rules = data[:tokens]
    @ignore_rules = data[:ignore]
    grammar_rules = data[:grammar]
    @grammar = Grammar.new(:PROGRAM)

    grammar_rules.each do |lhs, prods|
      prods.each do |symbols|
        # symbols[-1] = semantic action for the production
        action, symbols = symbols[-1], symbols[0..-2]
        symbols.each_with_index do |sym, i|
          if sym == :br
            symbols[i] = Rule.new(sym, /^\n$/)
          elsif sym.to_s.downcase == sym.to_s and sym != Grammar::EPSILON
            symbols[i] = Rule.new(sym, @token_rules[sym])
          end
        end
        @grammar.add_production(lhs, action, *symbols)
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

    @program_ast = self.syntactic_analysis
    SodaLogger.success("Lexical analysis completed successfuly")
    SodaLogger.success("Parsing completed successfuly")

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
    # TODO: we shouldn't be calling to_a here
    @tokens = @lexer.tokenize_file(@soda_file)
  end

  ##
  # Runs syntactic analysis

  def self.syntactic_analysis
    @parser = ENV['LLPARSE'] && LLParser.new(@grammar) || SLRParser.new(@grammar)
    @parser.parse(@tokens)
  end
end
