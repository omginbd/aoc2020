defmodule Aoc.Day15 do
  import Aoc.Utils

  def parse(filename) do
    filename
    |> get_lines(",")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  iex> part1()
  249
  """
  def part1(filename \\ "input15.txt") do
    numbers =
      filename
      |> parse

    numbers
    |> Enum.with_index(1)
    |> Enum.into(%{})
    |> play_game(List.last(numbers), Enum.count(numbers), 2020)
  end

  def play_game(last_turn_map, last_num, cur_turn, final_turn)

  def play_game(_, last_num, final_turn, final_turn) do
    last_num
  end

  def play_game(last_turn_map, last_num, cur_turn, final_turn) do
    last_turn =
      case Map.get(last_turn_map, last_num, 0) do
        ^cur_turn -> 0
        0 -> 0
        n -> cur_turn - n
      end

    play_game(Map.put(last_turn_map, last_num, cur_turn), last_turn, cur_turn + 1, final_turn)
  end

  @doc """
  # iex> part2()
  # 41687
  """
  def part2(filename \\ "input15.txt") do
    numbers =
      filename
      |> parse

    numbers
    |> Enum.with_index(1)
    |> Enum.into(%{})
    |> play_game(List.last(numbers), Enum.count(numbers), 30_000_000)
  end
end
