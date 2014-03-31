require 'test_helper'

describe Sodascript::SLRItem do
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
    prods = @g.productions.values.flatten
    @item0 = Sodascript::SLRItem.new(prods, [0] * 7)
    @item1 = Sodascript::SLRItem.new(prods[0..1], [1, 1])
    @item2 = Sodascript::SLRItem.new(prods[2..3], [1, 1])
    @item3 = Sodascript::SLRItem.new([prods[4]], [1])
    @item4 = Sodascript::SLRItem.new([prods[5]] + prods[1..6], [1] + [0] * 6)
    @item5 = Sodascript::SLRItem.new([prods[6]], [1])
    @item6 = Sodascript::SLRItem.new([prods[1]] + prods[3..6], [2] + [0] * 4)
    @item7 = Sodascript::SLRItem.new([prods[3]] + prods[5..6], [2, 0, 0])
    @item8 = Sodascript::SLRItem.new([prods[1], prods[5]], [1, 2])
    @item9 = Sodascript::SLRItem.new([prods[1], prods[3]], [3, 1])
    @item10 = Sodascript::SLRItem.new([prods[3]], [3])
    @item11 = Sodascript::SLRItem.new([prods[5]], [3])
  end

  describe "#initialize" do
    it "fails when the number of productions is not the number of positions" do
      prods = @item0.productions
      positions = [0] * (prods.size - 2)
      ->{ Sodascript::SLRItem.new(prods, positions) }.must_raise ArgumentError
    end
  end

  describe "#closure" do
    it "Expands the symbol at the index specified in postitions for each production" do
      prods = @item0.productions
      Sodascript::SLRItem.new([prods[0]], [0]).closure(@g).must_equal(@item0)
      Sodascript::SLRItem.new([prods[1]], [2]).closure(@g).must_equal(@item6)
      Sodascript::SLRItem.new([prods[5]], [1]).closure(@g).must_equal(@item4)
    end
  end

  describe "#goto" do
    it "computes an item that can be reached with a symbol" do
      @item0.goto(:E, @g).must_equal(@item1)
      @item0.goto(:T, @g).must_equal(@item2)
      @item0.goto(:id, @g).must_equal(@item5)
      @item0.goto(:'(', @g).must_equal(@item4)
      @item0.goto(:F, @g).must_equal(@item3)

      @item1.goto(:'+', @g).must_equal(@item6)
      @item2.goto(:'*', @g).must_equal(@item7)

      @item4.goto(:id, @g).must_equal(@item5)
      @item4.goto(:E, @g).must_equal(@item8)
      @item4.goto(:T, @g).must_equal(@item2)
      @item4.goto(:'(', @g).must_equal(@item4)

      @item6.goto(:T, @g).must_equal(@item9)
      @item6.goto(:F, @g).must_equal(@item3)
      @item6.goto(:'(', @g).must_equal(@item4)
      @item6.goto(:id, @g).must_equal(@item5)

      @item7.goto(:F, @g).must_equal(@item10)
      @item7.goto(:'(', @g).must_equal(@item4)
      @item7.goto(:id, @g).must_equal(@item5)

      @item8.goto(:')', @g).must_equal(@item11)
      @item8.goto(:'+', @g).must_equal(@item6)
    end


    it "returns an item of size 0 if no item can be reached" do
      @item0.goto(:X, @g).empty?.must_equal(true)
    end
  end

  describe "when asked if it's empty" do
    it "returns true if the size of the productions is 0" do
      Sodascript::SLRItem.new([], []).empty?.must_equal(true)
    end

    it "returns true if the size of the productions is 0" do
      @item0.empty?.must_equal(false)
    end
  end

  describe "#==" do
    it "returns true if the productions and the positions are the same" do
      c = @item0 == Sodascript::SLRItem.new(@item0.productions, [0] * 7)
      c.must_equal(true)
    end

    it "returns false if the productions and the positions are not the same" do
      p = Sodascript::Production.new(:E, :T)
      c = @item0 == Sodascript::SLRItem.new(@item0.productions, [1] * 7)
      c.must_equal(false)
      (@item0 == Sodascript::SLRItem.new([p] * 7, [1] * 7)).must_equal(false)
    end
  end

  describe "#each_production" do
    it "returns an enumerator of all the productions with their position" do
      ps = @item0.each_production
      ps.each_with_index do |result, i|
        r = @item0.productions[i] == result[0] && result[1] == @item0.positions[i]
        r.must_equal(true)
      end
    end

    it "can receive a block" do
      @item0.each_production.each_with_index do |result, i|
        r = @item0.productions[i] == result[0] && result[1] == @item0.positions[i]
        r.must_equal(true)
      end
    end
  end
end
