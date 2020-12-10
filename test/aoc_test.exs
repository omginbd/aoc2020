defmodule AocTest do
  use ExUnit.Case
  doctest Aoc
  doctest Aoc.Day01
  doctest Aoc.Day10

  test "greets the world" do
    assert Aoc.hello() == :world
  end
end
