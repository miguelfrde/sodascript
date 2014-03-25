require 'test_helper'

describe Sodascript::SLRTable do
  before do
    @g = Sodascript::Grammar.new(:Ep)
    @g.add_production(:Ep, :E)
    @g.add_production(:E, :E, Sodascript::Rule.new(:'+', /^\+$/), :T)
    @g.add_production(:E, :T)
    @g.add_production(:T, :T, Sodascript::Rule.new(:'*', /^\*$/), :F)
    @g.add_production(:T, :F)
    @g.add_production(:F, Sodascript::Rule.new(:'(', /^\($/), :E,
      Sodascript::Rule.new(:')', /^\)$/))
    @g.add_production(:F, Sodascript::Rule.new(:id, /^id$/))
    @table = Sodascript::SLRTable.new(
      @g.terminals.keys | [Sodascript::Grammar::END_SYM],
      @g.non_terminals
    )
  end

  describe "#shift" do
    it "adds a shift action to the table if the state is a terminal" do
      @table.shift(0, :'+', 1)
      @table.action(0, :'+').must_equal([Sodascript::SLRTable::SHIFT, 1])
    end

    it "adds a shift goto to the table if the state is a non-terminal" do
      @table.shift(0, :E, 2)
      @table.goto(0, :E).must_equal(2)
    end

    it "fails if the symbol is neither a terminal nor a non-terminal" do
      ->{ @table.shift(1, :BAD, 4) }.must_raise ArgumentError
    end

    it "raises a shift/shift conflict if there's already a shift action" do
      @table.shift(2, :E, 4)
      @table.shift(2, :'+', 3)
      ->{ @table.shift(2, :E, 5) }.must_raise ArgumentError
      ->{ @table.shift(2, :'+', 5) }.must_raise ArgumentError
    end

    it "raises a shift/reduce conflict if there's already a reduce action" do
      @table.reduce(2, :'+', 4)
      ->{ @table.shift(2, :'+', 4) }.must_raise ArgumentError
    end
  end

  describe "#reduce" do
    it "adds a reduce a action to the table if the state is a terminal" do
      @table.reduce(2, :'+', 4)
      @table.action(2, :'+').must_equal([Sodascript::SLRTable::REDUCE, 4])
    end

    it "fails if the state is not a terminal" do
      ->{ @table.reduce(2, :E, 4) }.must_raise ArgumentError
      ->{ @table.reduce(2, :'x', 4) }.must_raise ArgumentError
    end

    it "raises a shift/reduce conflict if there's already a shift action" do
      @table.reduce(2, :'+', 3)
      ->{ @table.shift(2, :'+', 3) }.must_raise ArgumentError
    end

    it "raises a reduce/reduce conflict if there's already a reduce action" do
      @table.reduce(2, :'+', 4)
      ->{ @table.reduce(2, :'+', 5) }.must_raise ArgumentError
    end
  end

  describe "#accept" do
    it "adds an accept action to the table if the state is a terminal" do
      @table.accept(3, Sodascript::Grammar::END_SYM)
      @table.action(3, Sodascript::Grammar::END_SYM).must_equal(Sodascript::SLRTable::ACCEPT)
    end

    it "fails if the state is not a terminal" do
      ->{ @table.accept(3, :E) }.must_raise ArgumentError
      ->{ @table.accept(3, :'x') }.must_raise ArgumentError
    end
  end

  describe "#action" do
    it "returns an action if the pair [state, symbol] is defined for action" do
      @table.shift(0, :'+', 3)
      @table.reduce(1, :'*', 3)
      @table.accept(2, :id)
      @table.action(0, :'+').must_equal([Sodascript::SLRTable::SHIFT, 3])
      @table.action(1, :'*').must_equal([Sodascript::SLRTable::REDUCE, 3])
      @table.action(2, :id).must_equal(Sodascript::SLRTable::ACCEPT)
    end

    it "returns nil if there is no defined action" do
      @table.action(3, :E).must_be_nil
      @table.action(2, :X).must_be_nil
      @table.action(1, :'*').must_be_nil
    end
  end

  describe "#goto" do
    it "returns a state if the pair [state, non-terminal] is defined for goto" do
      @table.shift(0, :E, 3)
      @table.goto(0, :E).must_equal(3)
    end

    it "returns nil if there is no defined action" do
      @table.goto(3, :E).must_be_nil
      @table.goto(2, :X).must_be_nil
      @table.goto(1, :'*').must_be_nil
    end
  end

  describe "#to_s" do
    before do
      @table.shift(0, :id, 5)
      @table.shift(0, :'(', 4)
      @table.shift(0, :E, 1)
      @table.shift(0, :T, 2)
      @table.shift(0, :F, 3)

      @table.shift(1, :'+', 6)
      @table.accept(1, Sodascript::Grammar::END_SYM)

      @table.reduce(2, :'+', 2)
      @table.reduce(2, :')', 2)
      @table.shift(2, :'*', 7)
      @table.reduce(2, Sodascript::Grammar::END_SYM, 2)

      @table.reduce(3, :'+', 4)
      @table.reduce(3, :'*', 4)
      @table.reduce(3, :')', 4)
      @table.reduce(3, Sodascript::Grammar::END_SYM, 4)

      @table.shift(4, :id, 5)
      @table.shift(4, :'(', 4)
      @table.shift(4, :E, 8)
      @table.shift(4, :T, 2)
      @table.shift(4, :F, 3)

      @table.reduce(5, :'+', 6)
      @table.reduce(5, :'*', 6)
      @table.reduce(5, :')', 6)
      @table.reduce(5, Sodascript::Grammar::END_SYM, 6)

      @table.shift(6, :id, 5)
      @table.shift(6, :'(', 6)
      @table.shift(6, :T, 9)
      @table.shift(6, :F, 3)

      @table.shift(7, :id, 5)
      @table.shift(7, :'(', 4)
      @table.shift(7, :F, 10)

      @table.shift(8, :'+', 6)
      @table.shift(8, :')', 11)

      @table.reduce(9, :'+', 1)
      @table.shift(9, :'*', 7)
      @table.reduce(9, :')', 1)
      @table.reduce(9, Sodascript::Grammar::END_SYM, 1)

      @table.reduce(10, :'+', 3)
      @table.reduce(10, :'*', 3)
      @table.reduce(10, :')', 3)
      @table.reduce(10, Sodascript::Grammar::END_SYM, 3)

      @table.reduce(11, :'+', 5)
      @table.reduce(11, :'*', 5)
      @table.reduce(11, :')', 5)
      @table.reduce(11, Sodascript::Grammar::END_SYM, 5)
    end

    it "returns the string representation of a grammar" do
      @table.to_s.must_equal(File.read('test/source/slrtable_expected.txt').strip)
    end
  end
end
