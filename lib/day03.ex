defmodule Aoc.Day03 do
  import Aoc.Utils

  def part1(filename \\ "input03.txt") do
    tree_map =
      filename
      |> get_lines
      |> build_tree_map()

    {width, height} = get_map_dimensions(tree_map)

    {tree_map, width, height}
    |> traverse({3, 1})
  end

  defp get_map_dimensions(tree_map) do
    Enum.reduce(Map.keys(tree_map), {0, 0}, fn {x, y}, {max_x, max_y} ->
      {max(x, max_x), max(y, max_y)}
    end)
  end

  defp build_tree_map(lines, y \\ 0, tree_map \\ %{})
  defp build_tree_map([head | tail], y, tree_map) do
    {_, new_tree_map} =
      head
      |> String.graphemes()
      |> Enum.reduce({0, tree_map}, fn elem, {x, trees} ->
        case elem do
          "#" -> {x + 1, Map.put(trees, {x, y}, 1)}
          _ -> {x + 1, trees}
        end
      end)
    build_tree_map(tail, y + 1, new_tree_map)
  end
  defp build_tree_map([], _, tree_map), do: tree_map

  defp traverse(map, velocity, pos \\ {0, 0}, trees_hit \\ 0)
  defp traverse({_, _, max_y}, _, {_, y}, trees_hit) when y > max_y, do: trees_hit
  defp traverse({tree_map, max_x, max_y}, {dx, dy}, {x, y}, trees_hit) do
    {new_x, new_y} = {x + dx, y + dy}
    looped_pos = {rem(new_x, max_x + 1), new_y}

    case Map.get(tree_map, looped_pos, 0) do
      1 -> traverse({tree_map, max_x, max_y}, {dx, dy}, {new_x, new_y}, trees_hit + 1)
      _ -> traverse({tree_map, max_x, max_y}, {dx, dy}, {new_x, new_y}, trees_hit)
    end
  end

  def part2(filename \\ "input03.txt") do
    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

    tree_map =
      filename
      |> get_lines
      |> build_tree_map()

    {width, height} = get_map_dimensions(tree_map)

    slopes
    |> Enum.map(fn slope -> traverse({tree_map, width, height}, slope) end)
    |> Enum.reduce(1, &(&1 * &2))
  end
end
