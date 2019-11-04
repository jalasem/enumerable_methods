#!/usr/bin/env ruby

# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ModuleLength
  def my_each
    arr = to_a
    return to_enum unless block_given?

    i = 0
    while i < size
      yield(arr[i])
      i += 1
    end
  end

  def my_each_with_index
    arr = to_a
    return to_enum unless block_given?

    i = 0
    while i < size
      yield(arr[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    result = []
    my_each { |element| result.push element if yield element }
    result
  end

  # rubocop:disable  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_all?(arg = nil)
    if block_given?
      my_each { |element| return false unless yield(element) }
    elsif arg.class == Class
      my_each { |element| return false unless element.class.ancestors.include? arg }
    elsif arg.class == Regexp
      my_each { |element| return false unless element =~ arg }
    elsif arg.nil?
      my_each { |element| return false unless element }
    else
      my_each { |element| return false unless element == arg }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |element| return true if yield element }
    elsif arg.class == Class
      my_each { |element| return true if element.class.ancestors.include? arg }
    elsif arg.class == Regexp
      my_each { |element| return true if arg =~ element }
    elsif arg.nil?
      my_each { |element| return true if element }
    else
      my_each { |element| return true if element == arg }
    end
    false
  end

  def my_none?(arg = nil)
    if block_given?
      my_each { |element| return false if yield element }
    elsif arg.class == Class
      my_each { |element| return false if element.class.ancestors.include? arg }
    elsif arg.class == Regexp
      my_each { |element| return false if arg =~ element }
    elsif arg.nil?
      my_each { |element| return false if element }
    else
      my_each { |element| return false if element == arg }
    end
    true
  end

  def my_count(arg = nil)
    c = 0 # c - count
    if block_given?
      my_each { |element| c += 1 if yield(element) }
    elsif arg.nil?
      my_each { |_element| c += 1 }
    else
      my_each { |element| c += 1 if element == arg }
    end
    c
  end

  def my_map
    return to_enum unless block_given?

    result = []
    if self.class == Range
      to_a.my_each_with_index { |element, index| result[index] = yield element }
    else
      my_each_with_index { |element, index| result[index] = yield element }
    end
    result
  end

  def my_inject(arg = nil, arg2 = nil)
    output = is_a?(Range) ? min : self[0]
    if block_given?
      my_each_with_index { |ele, i| output = yield(output, ele) if i.positive? }
      output = yield(output, arg) if arg
    elsif arg.is_a?(Symbol) || arg.is_a?(String)
      my_each_with_index { |ele, i| output = output.send(arg, ele) if i.positive? }
    elsif arg2.is_a?(Symbol) || arg2.is_a?(String)
      my_each_with_index { |ele, i| output = output.send(arg2, ele) if i.positive? }
      output = output.send(arg2, arg)
    elsif arg
      return "my_inject: #{arg} is not a symbol nor a string"
    else
      return 'my_inject: no block given'
    end
    output
  end
end
# rubocop:enable  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
