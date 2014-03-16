require 'test_helper'

describe Sodascript::Production do
  before do
    @p1 = Sodascript::Production.new(:S, :A, :B)
    @p2 = Sodascript::Production.new(:S, :A, :B)
    @p3 = Sodascript::Production.new(:S, :B, :A)
    @p4 = Sodascript::Production.new(:Z, :A, :B)
    @p5 = Sodascript::Production.new(:S, :A)
    @p6 = Sodascript::Production.new(:K, :D)
  end

  describe "#initialize" do
    it "fails when there are no symbols in the right-hand side" do
      ->{ Sodascript::Production.new(:test) }.must_raise ArgumentError
    end

    it "fails when the left-hand side is not a symbol" do
      ->{ Sodascript::Production.new('test') }.must_raise ArgumentError
      ->{ Sodascript::Production.new(0) }.must_raise ArgumentError
    end

    it "fails when the right-hand side contains something that is not a Symbol
        or a Rule" do
      ->{ Sodascript::Production.new(:test, 'a') }.must_raise ArgumentError
      ->{ Sodascript::Production.new(:test, :a, 'a') }.must_raise ArgumentError
      ->{ Sodascript::Production.new(:test, :a, 'a', :b) }.must_raise ArgumentError
      ->{ Sodascript::Production.new(:test, 0) }.must_raise ArgumentError
      ->{ Sodascript::Production.new(:test, :a, 0) }.must_raise ArgumentError
    end
  end

  describe "when checking if two Productions are equal" do
    it "returns true if the left-hand sides are equal and the right-hand sides
        are equal too" do
      (@p1 == @p2).must_equal(true)
    end

    it "returns false if the left-hand sides aren0t equal or the right-hand
        sides aren't equal" do
      (@p1 == @p3).must_equal(false)
      (@p1 == @p4).must_equal(false)
      (@p1 == @p5).must_equal(false)
      (@p1 == @p6).must_equal(false)
    end
  end
  
  describe "#to_s" do
    it "returns the string representation of a production" do
      @p1.to_s.must_equal('S -> A B')
      @p6.to_s.must_equal('K -> D')
    end
  end
end
