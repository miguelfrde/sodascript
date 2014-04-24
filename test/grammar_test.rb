require 'test_helper'

describe Sodascript::Grammar do
  before do
    @grammar = Sodascript::Grammar.new(:E)
    @grammar.add_production(:E, '', :T, :X)
    @grammar.add_production(:T, '', Sodascript::Rule.new(:lparen, /^\($/), :E,
                            Sodascript::Rule.new(:rparen, /^\)$/))
    @grammar.add_production(:T, '', Sodascript::Rule.new(:int, /^int$/), :Y)
    @grammar.add_production(:X, '', Sodascript::Rule.new(:plus, /^\+$/), :E)
    @grammar.add_production(:Y, '', Sodascript::Rule.new(:times, /^\*$/), :T)
    @grammar.add_production(:Y, '', Sodascript::Grammar::EPSILON)
    @grammar.add_production(:X, '', Sodascript::Grammar::EPSILON)
  end

  describe "when initilialized an initial symbol must be provided" do
    it "fails to initialize if the symbol is not a Symbol" do
      ->{ Sodascript::Grammar.new("S") }.must_raise ArgumentError
    end

    it "succeeds to initialize if the symbol is a Symbol" do
      grammar = Sodascript::Grammar.new(:S)
      grammar.must_be_instance_of(Sodascript::Grammar)
    end
  end

  describe "#add_production" do
    before do
      @grammar1 = Sodascript::Grammar.new(:S)
      @grammar1.add_production(:S, '', :Y, :X)
      @grammar1.add_production(:S, '', Sodascript::Rule.new(:test, /^test$/))
    end

    it "saves a new non-terminal if it wasn't used before" do
      size = @grammar1.non_terminals.size
      @grammar1.add_production(:New, '', :X, :Y)
      @grammar1.non_terminals.size.must_equal(size + 1)
    end

    it "doesn't save a new non-terminal if it was used before" do
      size = @grammar1.non_terminals.size
      @grammar1.add_production(:X, '', :Y)
      @grammar1.non_terminals.size.must_equal(size)
    end

    it "saves a new terminal if it wasn't used before" do
      size = @grammar1.terminals.size
      @grammar1.add_production(:X, '', Sodascript::Rule.new(:test2, /^test2$/))
      @grammar1.terminals.size.must_equal(size + 1)
    end

    it "doesn't save a new terminal if it was used before" do
      size = @grammar1.terminals.size
      @grammar1.add_production(:X, '', Sodascript::Rule.new(:test, /^test$/))
      @grammar1.terminals.size.must_equal(size)
    end

    it "saves the productions added" do
      size = @grammar1.productions.values.flatten.size
      @grammar1.add_production(:X, '', :Z)
      @grammar1.add_production(:Y, '', Sodascript::Rule.new(:y, /^y$/))
      @grammar1.productions.values.flatten.size.must_equal(size + 2)
    end

    it "adds epsilon to neither terminals nor non-terminals" do
      @grammar1.add_production(:X, '', Sodascript::Grammar::EPSILON)
      @grammar1.terminals.wont_include(Sodascript::Grammar::EPSILON)
    end

    it "fails if no rhs symbols are provided" do
      ->{ @grammar1.add_production(:Fail, '') }.must_raise ArgumentError
    end

    it "fails if the left-hand side is not a Symbol" do
      ->{ @grammar1.add_production("S", '', :Fail)}.must_raise ArgumentError
      ->{ @grammar1.add_production(2, '', :Fail)}.must_raise ArgumentError
    end

    it "fails if the rhs has something else than a Rule or Symbol" do
      ->{ @grammar1.add_production(:F, '', "string")}.must_raise ArgumentError
      ->{ @grammar1.add_production(:Fail, '', 1)}.must_raise ArgumentError
    end
  end

  describe "#first_set" do
    describe "when only a terminal is provided" do
      it "returns terminal t if t is the only argument" do
        set = @grammar.first_set(:int)
        set.size.must_equal(1)
        set.must_include(:int)
      end
    end

    describe "when only terminals are provided" do
      it "returns the first terminal only" do
        set = @grammar.first_set(:int, :lparen)
        set.size.must_equal(1)
        set.must_include(:int)
      end
    end

    describe "when provided non-terminals" do
      it "returns the union of the first of all non-terminals until one doesn't
          contain epsilon, without epsilon" do
        set = @grammar.first_set(:X, :Y, :T)
        res = @grammar.first_set(:X) | @grammar.first_set(:Y) |
          @grammar.first_set(:T)
        set.must_equal(res - Set.new([Sodascript::Grammar::EPSILON]))
      end

      it "returns the union of the first of all non-terminals (if their first
          contains epsilon) until a terminal is found, inclusive" do
        set = @grammar.first_set(:X, :Y, :int)
        res = @grammar.first_set(:X) | @grammar.first_set(:Y) | Set.new([:int])
        set.must_equal(res - Set.new([Sodascript::Grammar::EPSILON]))
      end

      it "returns the union of the first of all non-terminals with epsilon if
          all First(Non-terminal) contains epsilon" do
        set = @grammar.first_set(:X, :Y)
        set.must_equal(@grammar.first_set(:X) | @grammar.first_set(:Y))
      end
    end

    it "fails when no symbols are passed" do
      ->{ @grammar.first_set }.must_raise ArgumentError
    end

    it "fails when a symbol that doesn't exist is provided" do
      ->{ @grammar.first_set(:Fail) }.must_raise ArgumentError
      ->{ @grammar.first_set(:Fail1, :Fail2) }.must_raise ArgumentError
    end
  end

  describe "#follow_set" do
    describe "for the defined grammar" do
      it "returns the right Follow sets" do
        end_sym = Sodascript::Grammar::END_SYM
        expected_E = Set.new([:rparen, end_sym])
        expected_X = Set.new([:rparen, end_sym])
        expected_Y = Set.new([:plus, :rparen, end_sym])
        expected_T = Set.new([:plus, :rparen, end_sym])
        @grammar.follow_set(:E).difference(expected_E).must_equal(Set.new)
        @grammar.follow_set(:X).difference(expected_X).must_equal(Set.new)
        @grammar.follow_set(:Y).difference(expected_Y).must_equal(Set.new)
        @grammar.follow_set(:T).difference(expected_T).must_equal(Set.new)
      end
    end

    it "fails if a terminal is provided" do
      ->{ @grammar.follow_set(:int) }.must_raise ArgumentError
    end

    it "fails if the provided symbol is not defined" do
      ->{ @grammar.follow_set(:Z) }.must_raise ArgumentError
    end
  end

  describe "#to_s" do
    it "returns the string representation of a grammar" do
      g = Sodascript::Grammar.new(:S)
      g.add_production(:S, '', :A, :B)
      g.add_production(:A, '', Sodascript::Rule.new(:a, /^a$/), :A)
      g.add_production(:B, '', Sodascript::Grammar::EPSILON)
      g.add_production(:B, '', Sodascript::Rule.new(:a, /^a$/), :B)
      g.to_s.must_equal("a -> a\nS -> A B\nA -> a A\nB -> epsilon | a B")
    end
  end
end
