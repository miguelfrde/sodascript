require 'test_helper'

describe Sodascript::Rule do
  describe "#initialize" do
    it "fails when created with something else than a Symbol and a Regexp" do
      ->{ Sodascript::Rule.new(:name, 1) }.must_raise ArgumentError
      ->{ Sodascript::Rule.new('fail_args', /^fail$/) }.must_raise ArgumentError
      ->{ Sodascript::Rule.new(0, 's') }.must_raise ArgumentError
    end
  end

  describe "#matches?" do
    it "succeeds if the string passed matches the regex" do
      rule = Sodascript::Rule.new(:success, /ok|right/)
      rule.matches?('ok').wont_be_nil
      rule.matches?('right').wont_be_nil
    end

    it "fails if the string passed doesn't match the regex" do
      rule = Sodascript::Rule.new(:fail, /no|wrong/)
      rule.matches?('yes').must_be_nil
      rule.matches?('right').must_be_nil
    end
  end
end
