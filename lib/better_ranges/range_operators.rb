require 'better_ranges/sparse_range'

module BetterRanges
  module RangeOperators
    def |(other)
      SparseRange.new(self, *other)
    end

    def -(other)
      SparseRange.new(self) - other
    end

    def &(other)
      SparseRange.new(self) & other
    end

    alias_method :+, :|
    alias_method :union, :|

    alias_method :minus, :-
    alias_method :difference, :-
    alias_method :intersect, :&
  end
end

class Range
  include BetterRanges::RangeOperators
end
