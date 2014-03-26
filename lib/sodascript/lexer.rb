require 'sodascript/rule'
require 'sodascript/token'

module Sodascript

  ##
  # Lexer performs the lexical analysis process.

  class Lexer

    # Get all rules
    attr_reader :rules

    # Get all ignore rules
    attr_reader :ignore_rules

    ##
    # Lexer initialization.
    # If ignore_whitespace is defined then, when Lexer is extracting tokens,
    # it will ignore whitespaces.

    def initialize(ignore_whitespace = true)
      @rules = []
      @ignore_rules = []
      @ignore_rules << Rule.new(:whitespace, /^\s+$/) if ignore_whitespace
    end

    ##
    # Adds a rule to the Lexer list of rules.

    def add_rule(name, regex)
      @rules << Rule.new(name, regex)
    end

    ##
    # Adds a rule to the list of things to ignore.

    def ignore(name, regex)
      @ignore_rules << Rule.new(name, regex)
    end

    ##
    # Performs the lexical analysis over _filename_ using the defined rules.

    def tokenize_file(file_name)
      tokenize(File.read(file_name))
    end

    ##
    # Performs the lexical analysis over _string_ using the defined rules.

    def tokenize(string)
      return to_enum(:tokenize, string) unless block_given?
      current  = ''
      previous = ''
      identifies_previous = false
      line = 0
      errors_found = false
      string.each_char do |c|
        br_found = false
        if previous == '$' || ignores?(previous)
          previous = ''
          current = ''
        end

        # NOTE: This fix is needed since "\n" =~ /$^/ is true
        if c == "\n"
          c = "$"
          br_found = true
          line += 1
        end

        current << c
        identifies_current = identifies?(current)

        # If current doesn't match and previous matches, then previous is a token
        # If none of them matched, then continue with next character
        if !identifies_current && identifies_previous
          yield get_token(previous)
          previous = c.clone
          current = c.clone
          identifies_previous = identifies?(previous)
        else
          previous << c
          identifies_previous = identifies_current
        end

        yield Token.new(Rule.new(:br, /^\n$/), "\n") if br_found

        if br_found && !ignores?(current) && current != "$"
          SodaLogger.error("Unknown tokens in line #{line}: #{current[0..-2]}")
          previous = ''
          current = ''
          errors_found = true
        end

      end

      unless previous.empty? || ignores?(previous) || previous == '$'
        token = get_token(previous)
        raise "Unknown token '#{previous}' in the end" if token.nil?
        yield token
      end

      backtrace = ENV.has_key?('SODA_DEBUG')
      SodaLogger::fail("Errors found while performing lexical analysis", backtrace)
    end

    ##
    # Checks if _string_ matches any of the defined rules.

    def identifies?(string)
      @rules.each { |rule| return true if rule.matches?(string) }
      false
    end

    ##
    # Checks if _string_ matches any of the defined ignore rules.

    def ignores?(string)
      @ignore_rules.each { |ir| return true if ir.matches?(string) }
      false
    end

    ##
    # Matches _string_ against each defined rule and returns the token of the
    # first match or `nil` if there is no matching rule.

    def get_token(string)
      @rules.each do |rule|
        return Token.new(rule, string) if rule.matches?(string)
      end
      nil
    end
  end
end
