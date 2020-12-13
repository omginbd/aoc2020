defmodule AocTest do
  use ExUnit.Case
  doctest Aoc
  doctest Aoc.Day01
  doctest Aoc.Day10
  doctest Aoc.Day11
  doctest Aoc.Day12
  doctest Aoc.Day13

  test "greets the world" do
    assert Aoc.hello() == :world
  end
end
