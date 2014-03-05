require 'better_ranges/sparse_range'

module BetterRanges
  module RangeOperators
    def |(x)
      SparseRange.new(self, *x)
    end

    def -(x)
      SparseRange.new(self) - x
    end

    def &(x)
      SparseRange.new(self) & x
    end

    alias :+ :|
  end
end

class Range
  include BetterRanges::RangeOperators
end
