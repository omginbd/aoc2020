defmodule Aoc.Day13 do
  import Aoc.Utils

  @doc """
  iex> Aoc.Day13.part1
  261
  """
  def part1(filename \\ "input13.txt") do
    [departure_time, schedule] =
      filename
      |> get_lines

    departure_time = String.to_integer(departure_time)

    {best_id, best_wait} =
      schedule
      |> String.replace("x,", "")
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({-1, {}}, fn bus_id, {best_id, best_time} ->
        (bus_id * (Integer.floor_div(departure_time, bus_id) + 1))
        |> case do
          n when n - departure_time < best_time -> {bus_id, n - departure_time}
          _ -> {best_id, best_time}
        end
      end)

    best_id * best_wait
  end

  @doc """
  iex> Aoc.Day13.part2
  807435693182510
  """
  def part2(filename \\ "input13.txt") do
    [_, schedule] =
      filename
      |> get_lines

    schedule
    |> String.split(",")
    |> Stream.with_index()
    |> Stream.filter(&(elem(&1, 0) !== "x"))
    |> Enum.map(fn {e, i} -> {String.to_integer(e), i} end)
    |> find_first_time
  end

  # Cobbled together chinese remainder theorem lmao glhf understanding
  def find_first_time(buses) do
    bigN =
      buses
      |> Enum.map(&elem(&1, 0))
      |> Enum.reduce(1, &Kernel.*/2)

    x =
      buses
      |> Enum.map(fn {n, a} ->
        ni = Integer.floor_div(bigN, n)
        xi = find_xi(ni, n, 1)
        ni * xi * a
      end)
      |> Enum.sum()
      |> Kernel.rem(bigN)

    bigN - x
  end

  def find_xi(ni, n, x) do
    case rem(x * ni, n) do
      1 -> x
      _ -> find_xi(ni, n, x + 1)
    end
  end
end
