require 'sodascript/lexer'
require 'sodascript/token'
require 'sodascript/rule'

##
# Main module of gem.
# It's used to compile a sodascript file to a javascript file.

module Sodascript

  ##
  # Compiles the contents of the soda file and saves them to the js file.
  #
  # :args: soda_file, js_file

  def self.execute(*args)
    abort 'Wrong arguments, see help' unless args.size == 2
    @soda_file = args[0]
    @js_file = args[1]
    self.compile
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
  # ---
  # TODO: Instead of hardcoding rules here we should load them from a file
  # +++

  def self.lexical_analysis
    @lexer = Lexer.new
    @lexer.add_rule(:identifier, /^[a-zA-Z_][\w-]*$/)
    @lexer.add_rule(:number, /^\d+(\.\d*)?$/)
    @lexer.add_rule(:string, /^("[^"]*"|'[^']*')$/)
    @lexer.tokenize_file(@soda_file)
  end
end
