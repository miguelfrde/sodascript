require 'test_helper'

describe Sodascript::Lexer do
  before do
    @lexer = Sodascript::Lexer.new
    @lexer.add_rule(:test, /^test$/)
  end

  describe "#initialize" do
    it "has one ignore rule defined if ignore_whitespace is set" do
      lexer = Sodascript::Lexer.new(ignore_whitespace = true)
      lexer.ignore_rules.size.must_equal(1)
    end

    it "has one ignore rule by default" do
      lexer = Sodascript::Lexer.new
      lexer.ignore_rules.size.must_equal(1)
    end

    it "has no ignore rules defined if ignore_whitespace is not set" do
      lexer = Sodascript::Lexer.new(ignore_whitespace = false)
      lexer.ignore_rules.size.must_equal(0)
    end

    it "has zero rules defined" do
      lexer = Sodascript::Lexer.new
      lexer.rules.size.must_equal(0)
    end
  end

  describe "#add_rule" do
    it "has one rule defined after calling the method" do
      lexer = Sodascript::Lexer.new
      lexer.add_rule(:test, /^test$/)
      lexer.rules.size.must_equal(1)
    end
  end

  describe "#ignore" do
    it "has one more ignore rule defined after calling it" do
      i = @lexer.ignore_rules.size
      @lexer.ignore(:test, /^ignore$/)
      @lexer.ignore_rules.size.must_equal(i + 1)
    end
  end

  describe "#identifies?" do
    it "is true when the string matches a defined rule" do
      @lexer.identifies?("test").must_equal(true)
    end

    it "is false when the string matches a defined rule" do
      @lexer.identifies?("no").must_equal(false)
    end
  end

  describe "#ignores" do
    it "is true when the string matches a defined ignore rule" do
      @lexer.ignores?(" ").must_equal(true)
    end

    it "is false when the string matches a defined ignore rule" do
      @lexer.ignores?("x").must_equal(false)
    end
  end

  describe "#get_token" do
    it "returns a Token which lexeme is string and rule is the matched Rule if
        it matches some rule" do
      token = @lexer.get_token("test")
      token.must_be_instance_of(Sodascript::Token)
      token.rule.name.must_equal(:test)
      "test".must_match(token.rule.regex)
    end

    it "returns nil if no defined rule is matched" do
      @lexer.get_token("no").must_be_nil
    end
  end

  describe "#tokenize" do
    it "returns a list of matched tokens which lexemes are all identified" do
      @lexer.add_rule(:test2, /^test\d$/)
      @lexer.add_rule(:test3, /^mytest$/)
      tokens = @lexer.tokenize('test test2 mytest')
      tokens.all?{ |token| @lexer.identifies?(token.lexeme)}.must_equal(true)
    end
  end
end
