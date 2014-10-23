require 'spec_helper'
include BetterRanges

describe BetterRanges::SparseRange do
  context 'difference(#-)' do
    it 'should work' do
      a = SparseRange.new(-20..-10, 1..25, 50..75, 100..200, 300..400, 500..600, 700..800, 900)
      b = SparseRange.new(-5..-1, 5..15, 40..80, 90..125, 150..225, 250..350, 550..650, 750, 850..950, 1000)

      (a - a).should be_empty
      (a - b).should eq [-20..-10, 1...5, 16..25, 126...150, 351..400, 500...550, 700...750, 751..800]
    end
  end

  context 'intersection(#&)' do
    a = SparseRange.new(1..10, 20..30, 40..50, 60..80)
    b = SparseRange.new(10..20, 30..40, 65..75)

    it 'should work' do
      (a & a).should eq a
      (a & b).should eq [10, 20, 30, 40, 65..75]
    end

    it 'should be commutative' do
      (a & b).should eq(b & a)
    end
  end

  context 'union(#|)' do
    a = SparseRange.new(1..10, 20..30, 40..50, 60..80)
    b = SparseRange.new(10..20, 30..40, 65..75)

    it 'should work' do
      (a | b).should eq [1..50, 60..80]
    end

    it 'should be commutative' do
      (a | b).should eq(b | a)
    end
  end

end
