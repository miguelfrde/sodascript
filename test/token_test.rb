require 'test_helper'

describe Sodascript::Token do
  before do
    @rule  = Sodascript::Rule.new(:test, /^test$/)
  end

  describe "#initialize" do
    it "fails when created with something else than a Rule and a String" do
      ->{ Sodascript::Token.new(@rule, 1) }.must_raise ArgumentError
      ->{ Sodascript::Token.new('fail_args', 'fail_args') }.must_raise ArgumentError
      ->{ Sodascript::Token.new(/^fail$/, @rule) }.must_raise ArgumentError
    end

    it "fails when string doesn't match rule.regex" do
      ->{ Sodascript::Token.new(@rule, 'fail') }.must_raise ArgumentError
    end
  end

  describe "when asked for rule and lexeme" do
    it "Token's rule matches lexeme" do
      token = Sodascript::Token.new(@rule, 'test')
      token.lexeme.must_match(token.rule.regex)
    end
  end
end
