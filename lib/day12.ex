defmodule Aoc.Day12 do
  import Aoc.Utils

  @doc """
  iex> Aoc.Day12.part1
  1424
  """
  def part1(filename \\ "input12.txt") do
    {_, {x, y}} =
      filename
      |> get_lines
      |> Enum.map(fn line ->
        [_, command, value] = Regex.run(~r/(\w)(\d+)/, line)
        {command, String.to_integer(value)}
      end)
      |> follow_navigation

    abs(x) + abs(y)
  end

  @doc """
  iex> Aoc.Day12.part2
  63447
  """
  def part2(filename \\ "input12.txt") do
    {_, {x, y}} =
      filename
      |> get_lines
      |> Enum.map(fn line ->
        [_, command, value] = Regex.run(~r/(\w)(\d+)/, line)
        {command, String.to_integer(value)}
      end)
      |> follow_waypoint_navigation

    abs(x) + abs(y)
  end

  def follow_navigation(commands, direction \\ 0, current_position \\ {0, 0})

  def follow_navigation([{"N", value} | tail], direction, {x, y}) do
    follow_navigation(tail, direction, {x, y + value})
  end

  def follow_navigation([{"S", value} | tail], direction, {x, y}) do
    follow_navigation(tail, direction, {x, y - value})
  end

  def follow_navigation([{"E", value} | tail], direction, {x, y}) do
    follow_navigation(tail, direction, {x + value, y})
  end

  def follow_navigation([{"W", value} | tail], direction, {x, y}) do
    follow_navigation(tail, direction, {x - value, y})
  end

  def follow_navigation([{"F", value} | tail], direction, pos) do
    follow_navigation(tail, direction, go_forward(pos, direction, value))
  end

  def follow_navigation([{"R", value} | tail], direction, cur_position) do
    follow_navigation(tail, turn_right(direction, value), cur_position)
  end

  def follow_navigation([{"L", value} | tail], direction, cur_position) do
    follow_navigation(tail, turn_left(direction, value), cur_position)
  end

  def follow_navigation([], dir, pos), do: {dir, pos}

  def turn_left(cur_dir, rotation), do: rem(cur_dir + rotation + 360, 360)
  def turn_right(cur_dir, rotation), do: rem(cur_dir - rotation + 360, 360)

  def go_forward({x, y}, dir, val) do
    case dir do
      0 -> {x + val, y}
      90 -> {x, y + val}
      180 -> {x - val, y}
      270 -> {x, y - val}
    end
  end

  def follow_waypoint_navigation(commands, waypoint_position \\ {10, 1}, ship_position \\ {0, 0})

  def follow_waypoint_navigation([{"N", value} | tail], {wx, wy}, ship_pos),
    do: follow_waypoint_navigation(tail, {wx, wy + value}, ship_pos)

  def follow_waypoint_navigation([{"E", value} | tail], {wx, wy}, ship_pos),
    do: follow_waypoint_navigation(tail, {wx + value, wy}, ship_pos)

  def follow_waypoint_navigation([{"S", value} | tail], {wx, wy}, ship_pos),
    do: follow_waypoint_navigation(tail, {wx, wy - value}, ship_pos)

  def follow_waypoint_navigation([{"W", value} | tail], {wx, wy}, ship_pos),
    do: follow_waypoint_navigation(tail, {wx - value, wy}, ship_pos)

  def follow_waypoint_navigation([{"F", value} | tail], {wx, wy}, {sx, sy}) do
    follow_waypoint_navigation(tail, {wx, wy}, {value * wx + sx, value * wy + sy})
  end

  def follow_waypoint_navigation([{"L", value} | tail], {wx, wy}, ship_pos) do
    new_waypoint_pos =
      value
      |> case do
        90 -> {-1 * wy, wx}
        180 -> {-1 * wx, -1 * wy}
        270 -> {wy, -1 * wx}
      end

    follow_waypoint_navigation(tail, new_waypoint_pos, ship_pos)
  end

  def follow_waypoint_navigation([{"R", value} | tail], {wx, wy}, ship_pos) do
    new_waypoint_pos =
      value
      |> case do
        270 -> {-1 * wy, wx}
        180 -> {-1 * wx, -1 * wy}
        90 -> {wy, -1 * wx}
      end

    follow_waypoint_navigation(tail, new_waypoint_pos, ship_pos)
  end

  def follow_waypoint_navigation([], waypoint_pos, ship_pos), do: {waypoint_pos, ship_pos}
end
