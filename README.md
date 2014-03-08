[![Gem Version](https://badge.fury.io/rb/better_ranges.png)](http://badge.fury.io/rb/better_ranges)

# BetterRanges

Adds support for basic set operations to the ruby Range class through the addition of a new SparseRange class.
A SparseRange supports all the same methods as a Range plus a few more, most importantly minus (-), intersect (&), and union (|).

The purpose of this library is efficiency and convenience. The usual way to achieve these functions is by either first converting the ranges to arrays, which can be slow, or by manually comparing their bounds, which is tedious, especially for more than 2 ranges.

## Installation

Add this line to your application's Gemfile:

    gem 'better_ranges'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_ranges

## Usage

Just `require 'better_ranges'` and you're good to go.

## Examples

```
(1..20) - (8..12) - 5 => SparseRange(1...5, 6..7, 13..20)

(1..20) & (15..25)    => SparseRange(15..20)

(1..10) | (5..15)     => SparseRange(1..15)

```