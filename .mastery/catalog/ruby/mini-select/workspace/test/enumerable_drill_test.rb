require "minitest/autorun"
require_relative "../lib/enumerable_drill"

class EnumerableDrillTest < Minitest::Test
  def test_selects_items_that_match_the_block
    result = EnumerableDrill.my_select([1, 2, 3, 4, 5]) { |number| number.odd? }

    assert_equal [1, 3, 5], result
  end

  def test_preserves_original_order
    result = EnumerableDrill.my_select(%w[ruby rails rack rspec]) { |word| word.start_with?("r") }

    assert_equal %w[ruby rails rack rspec], result
  end

  def test_returns_empty_array_when_nothing_matches
    result = EnumerableDrill.my_select([10, 20, 30]) { |number| number < 5 }

    assert_equal [], result
  end

  def test_does_not_mutate_the_input
    input = [1, 2, 3]

    EnumerableDrill.my_select(input) { |number| number > 1 }

    assert_equal [1, 2, 3], input
  end

  def test_requires_a_block
    assert_raises(ArgumentError) do
      EnumerableDrill.my_select([1, 2, 3])
    end
  end

  def test_does_not_use_builtin_select_family
    source = File.read(File.expand_path("../lib/enumerable_drill.rb", __dir__))

    refute_match(/\.(select|filter|find_all)\b/, source)
  end
end
