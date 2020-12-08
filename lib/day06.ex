defmodule Aoc.Day06 do
  import Aoc.Utils

  def part1(filename \\ "input06.txt") do
    filename
    |> get_lines("\n\n")
    |> Stream.map(&String.split(&1, "\n"))
    |> Stream.map(&get_group_questions/1)
    |> Stream.map(&(Map.keys(&1) |> Enum.count()))
    |> Enum.sum()
  end

  def part2(filename \\ "input06.txt") do
    filename
    |> get_lines("\n\n")
    |> Stream.map(&String.split(&1, "\n"))
    |> Stream.map(&{Enum.count(&1), get_group_questions(&1)})
    |> Stream.map(fn {group_total, group_answers} ->
      group_answers
      |> Map.values()
      |> Enum.filter(&(&1 === group_total))
      |> Enum.count()
    end)
    |> Enum.sum
  end

  def get_group_questions(list, yes_map \\ %{})

  def get_group_questions([head | tail], yes_map) do
    new_yes_map =
      head
      |> String.graphemes()
      |> Enum.reduce(yes_map, fn q, acc -> Map.update(acc, q, 1, &(&1 + 1)) end)

    get_group_questions(tail, new_yes_map)
  end

  def get_group_questions([], yes_map), do: yes_map
end
