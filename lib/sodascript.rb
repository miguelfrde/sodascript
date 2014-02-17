require 'sodascript/lexer'
require 'sodascript/token'
require 'sodascript/rule'

module Sodascript

  def self.execute(*args)
    abort 'Wrong arguments, see help' unless args.size == 2
    @soda_file = args[0]
    @js_file = args[1]
    self.compile
  end

  private

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

  def self.lexical_analysis
    @lexer = Lexer.new
    # TODO: Instead of hardcoding rules here we should load them from a file
    @lexer.add_rule(:identifier, /^[a-zA-Z_][\w-]*$/)
    @lexer.add_rule(:number, /^\d+(\.\d*)?$/)
    @lexer.add_rule(:string, /^("[^"]*"|'[^']*')$/)
    @lexer.tokenize(@soda_file)
  end
end
