defmodule Aoc.Day07 do
  import Aoc.Utils

  def part1(filename \\ "input07.txt") do
    filename
    |> get_lines()
    |> build_rule_map
    |> find_containing_bags(["shiny gold"])
    |> Enum.count()
  end

  def part2(filename \\ "input07.txt") do
    filename
    |> get_lines()
    |> build_rule_map
    |> count_children("shiny gold")
  end

  def build_rule_map(rules, rule_map \\ %{})

  def build_rule_map([head | tail], rule_map) do
    [_, parent_color, contains] = Regex.run(~r/(\w+ \w+) bags contain (.+)\./, head)

    case contains do
      "no other bags" ->
        build_rule_map(tail, Map.put(rule_map, parent_color, []))

      _ ->
        children =
          contains
          |> String.split(",", trim: true)
          |> Enum.map(fn child ->
            [_, num, color] = Regex.run(~r/(\d+) (\w+ \w+)/, child)
            {String.to_integer(num), color}
          end)

        build_rule_map(tail, Map.put(rule_map, parent_color, children))
    end
  end

  def build_rule_map([], rule_map), do: rule_map

  def find_containing_bags(rule_map, colors_to_find) do
    found_colors =
      rule_map
      |> Map.keys()
      |> Enum.filter(fn parent_color ->
        children = Map.get(rule_map, parent_color, []) |> Enum.map(fn {_, color} -> color end)
        without_search = children -- colors_to_find
        Enum.count(children) > Enum.count(without_search)
      end)

    case found_colors -- colors_to_find do
      [] -> found_colors
      _ -> find_containing_bags(rule_map, found_colors ++ colors_to_find)
    end
  end

  def count_children(rule_map, parent_color)

  def count_children(rule_map, parent_color) do
    rule_map
    |> Map.get(parent_color, [])
    |> Enum.map(fn {n, color} -> n * (count_children(rule_map, color) + 1) end)
    |> Enum.sum()
  end
end
