# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ModuleLength
  def my_each
    return to_enum unless block_given?
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum unless block_given?
    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?
    result = []
    my_each { |e| result.push e if yield e }
    result
  end

  def my_all?(arg = nil)
    if block_given?
    result = true
    my_each { |e| result = false unless yield e}
    elsif arg.class == Class
      my_each { |e| result = false unless e.class == arg }
    elsif arg.class == Regexp
      my_each { |e| result = false unless e =~ arg }
    elsif arg.nil?
      my_each { |e| result = false unless e }
    else
      my_each { |e| result = false unless e == arg }
    end
    result
  end

  def my_any?(arg = nil)
    if block_given?
    result = false

    my_each { |e| result = true unless yield e}
    elsif arg.class == Class
      my_each { |e| result = true unless e.class == arg }
    elsif arg.class == Regexp
      my_each { |e| result = true unless e =~ arg }
    elsif arg.nil?
      my_each { |e| result = true unless e }
    else
      my_each { |e| result = true unless i == arg }
    end
    result
  end

  def my_none?(arg = nil)
    if block_given?
    result = true
    my_each { |e| result = false unless yield e}
    elsif arg.class == Class
      my_each { |e| result = false unless e.class == arg }
    elsif arg.class == Regexp
      my_each { |e| result = false unless e =~ arg }
    elsif arg.nil?
      my_each { |e| result = false unless e }
    else
      my_each { |e| result = false unless i == arg }
    end
    result
  end

  def my_count(num = nil)
    count = 0
    if block_given?
    if num
      my_each do |e|
        count += 1 if e == num
      end
    else
      my_each do |e|
        count += 1 if yield e
      end
    end
    count
  end

  def my_map(proc = nil)
    return to_enum unless block_given?
    result = []
    if proc
      my_each_with_index do |e, i|
        result[i] = proc.call(e)
      end
    else
      my_each_with_index do |e, i|
        result[i] = yield e
      end
    end
    result
  end

  def my_inject(*args)
    arr = to_a.dup
    if args[0].nil?
      operand = arr.shift
    elsif args[1].nil? && !block_given?
      symbol = args[0]
      operand = arr.shift
    elsif args[1].nil? && block_given?
      operand = args[0]
    else
      operand = args[0]
      symbol = args[1]
    end

    arr[0..-1].my_each do |i|
      operand = if symbol
                  operand.send(symbol, i)
                else
                  yield(operand, i)
                end
    end
    operand
  end
end

def multiply_els(array)
  array.my_inject(:*)
end

