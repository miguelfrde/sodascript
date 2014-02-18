require 'sodascript/rule'
require 'sodascript/token'

module Sodascript

  ##
  # Lexer performs the lexical analysis process.

  class Lexer

    ##
    # Lexer initialization.
    # If ignore_whitespace is defined then, when Lexer is extracting tokens,
    # it will ignore whitespaces.

    def initialize(ignore_whitespace = true)
      @rules = []
      @ignore = []
      @ignore << Rule.new(:whitespace, /^\s+$/) if ignore_whitespace
    end
    
    ##
    # Adds a rule to the Lexer list of rules.

    def add_rule(name, regex)
      @rules << Rule.new(name, regex)
    end

    ##
    # Adds a rule to the list of things to ignore.

    def ignore(name, regex)
      @ignore << Rule.new(name, regex)
    end

    ##
    # Performs the lexical analysis over _filename_ using the defined rules.

    def tokenize(file_name)
      current  = ''
      previous = ''
      tokens = []
      identifies_previous = false

      File.read(file_name).each_char do |c|
        if ignores?(previous)
          previous = ''
          current = ''
        end

        # NOTE: This fix is needed since "\n" =~ /$^/ is true
        c = (c == "\n" && ' ') || c
        
        current << c
        identifies_current = identifies?(current)

        # If current doesn't match and previous matches, then previous is a token
        # If none of them matched, then continue with next character
        if !identifies_current && identifies_previous
          tokens << get_token(previous)
          previous = c.clone
          current = c.clone
          identifies_previous = false
        else
          previous << c
          identifies_previous = identifies_current
        end

      end

      unless previous.empty? || ignores?(previous)
        token = get_token(previous)
        raise "Unknown token '#{previous}' in the end" if token.nil?
        tokens << token
      end

      tokens
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
      @ignore.each { |ir| return true if ir.matches?(string) }
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
