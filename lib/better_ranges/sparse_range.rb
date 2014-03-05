module BetterRanges
  class SparseRange
    include Enumerable

    def initialize(*data)
      @ranges = [*data].map! do |x|
        if (x.is_a?(Enumerable))
          if (x.none?)
            return nil
          elsif (x.is_a?(SparseRange))
            return x.ranges.clone
          end
        end
        x
      end
      optimize
    end

    def each(&block)
      Enumerator.new do |yielder|
        @ranges.each do |r|
          yield_each(r){ |x| yielder.yield x}
        end
      end.each(&block)
    end

    def step(num = 1, &block)
      i = 0
      Enumerator.new do |yielder|
        @ranges.each do |r|
          yield_each(r) do |x|
            yielder.yield x if ((i % num) == 0)
            i += 1
          end
        end
      end.each(&block)
    end

    def last
      read_val(@ranges.last).last
    end

    def |(x)
      SparseRange.new(@ranges, *x)
    end

    def -(x)
      diff = SparseRange.new
      diff_data = diff.ranges

      i = 0
      next_val = lambda do
        throw :done unless i < @ranges.length
        v = read_val(@ranges[i])
        i += 1
        v
      end

      catch(:done) do
        other = (x.is_a?(SparseRange) ? x : SparseRange.new(x)).ranges

        start, finish = next_val.call
        other.each do |r|
          other_start, other_finish = read_val(r)

          while (finish < other_start)
            diff_data << write_val(start, finish)
            start, finish = next_val.call
          end
          next if other_finish < start

          diff_data << (start.succ == other_start ? start : (start...other_start)) if start < other_start

          start = other_finish.succ
          start, finish = next_val.call if start > finish
        end
        diff_data << write_val(start, finish)
        loop { diff_data << write_val(*next_val.call) }
      end

      diff
    end

    def &(x)
      intersect = SparseRange.new
      intersect_data = intersect.ranges

      i = 0
      next_val = lambda do
        throw :done unless i < @ranges.length
        v = read_val(@ranges[i])
        i += 1
        v
      end

      catch(:done) do
        other = (x.is_a?(SparseRange) ? x : SparseRange.new(x)).ranges

        start, finish = next_val.call
        other.each do |r|
          other_start, other_finish = read_val(r)
          start, finish = next_val.call while (finish < other_start)

          until other_finish < start
            first = [start, other_start].max
            last = [finish, other_finish].min

            intersect_data << write_val(first, last)

            start = last.succ
            if start < other_finish
              other_start = start
              start, finish = next_val.call
            end
          end
        end
      end

      intersect
    end

    def <<(x)
      @ranges << [*(x.is_a?(SparseRange) ? x.ranges : x)]
      optimize

      self
    end

    def inspect
      @ranges.inspect
    end

    def include?(x)
      @ranges.any? do |r|
        r.is_a?(Range) ? r.include?(x) : x == r
      end
    end

    def empty?
      @ranges.empty?
    end

    def size
      @ranges.inject(0){|c, x| c + (x.is_a?(Range) ? x.count : 1)}
    end

    def ==(x)
      other = (x.is_a?(SparseRange) ? x : SparseRange.new(x)).ranges
      i = 0
      (@ranges.length == other.length) && @ranges.all? do |e|
        o = other[i]
        i += 1
        (e == o) || (read_val(e) == read_val(o))
      end
    end

    # TODO: Calculate hash without creating the temp array
    def hash
      @ranges.map(&method(:read_val)).hash
    end

    alias :+ :|
    alias :union :|

    alias :minus :-
    alias :intersect :&

    alias :add :<<

    alias :cover? :include?
    alias :=== :include?

    alias :eql? :==

    protected
    attr_reader :ranges

    def yield_each(e)
      if (e.is_a?(Range))
        e.each{|x| yield x}
      else
        yield e
      end
    end

    private

    def read_val(x)
      x.is_a?(Range) ? [x.first, (x.exclude_end? ? x.max : x.last)] : [x, x]
    end

    def write_val(start, finish)
      (start != finish ? (start..finish) : finish)
    end

    def optimize
      @ranges.flatten!
      @ranges.compact!
      @ranges.sort!{|a,b| (a <=> b) || (read_val(a) <=> read_val(b))}

      fixed = []
      start, finish = read_val(@ranges.first)

      for i in (1...@ranges.length)
        first, last = read_val(@ranges[i])

        if (finish.succ >= first)
          finish = last if last > finish
        else
          fixed << write_val(start, finish)
          start, finish = first, last
        end
      end
      fixed << write_val(start, finish) if finish

      @ranges = fixed
    end
  end
end

class Range
  include Comparable

  def <=>(other)
    comp = nil
    if (other.is_a?(Range) || other.is_a?(BetterRanges::SparseRange))
      comp = (first <=> other.first)
      comp = (last <=> other.last) if comp == 0
      if comp == 0
        comp = -1 if exclude_end? && !other.exclude_end?
        comp = 1 if !exclude_end? && other.exclude_end?
      end
    else
      comp = (first <=> other)
      comp = (last <=> other) if comp == 0
      comp = -1 if comp == 0 && exclude_end?
    end
    comp
  end
end