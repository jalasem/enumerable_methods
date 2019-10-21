# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ModuleLength
  def my_each
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    result = []
    my_each do |e|
      if yield e
        result.push e
      end
    end
    result
  end

  def my_all?
    result = true
    my_each do |e|
      result = false unless yield e
    end
    result
  end

  def my_any?
    result = false
    my_each do |e|
      if yield e
        result = true
        break
      end
    end
    result
  end

  def my_none?
    result = true
    my_each do |e|
      if yield e
        result = false
        break
      end
    end
    result
  end

  def my_count(num = nil)
    count = 0
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
    case args.length
    when 1
      if args[0].class == Symbol
        memo = self[0]
        my_each_with_index do |e, i|
          next if i == 0
          memo = memo.method(args[0]).call(e)
        end
      else
        memo = args[0]
        my_each do |e|
          memo = yield(memo, e)
        end
      end
    when 2
      memo = args[0]
      my_each do |e|
        memo = memo.method(args[1]).call(e)
      end
    else
      memo = self[0]
      my_each_with_index do |e, i|
        next if i == 0
        memo = yield(memo, e)
      end
    end
    memo
  end
end

def multiply_els(array)
  array.my_inject(:*)
end
