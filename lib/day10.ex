defmodule Aoc.Day10 do
  import Aoc.Utils

  @doc """
  iex> Aoc.Day10.part1()
  "74 * 34 = 2516"
  """
  def part1(filename \\ "input10.txt") do
    {num_ones, num_threes} =
      filename
      |> get_lines()
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
      |> add_final_device_joltage
      |> calculate_jolt_diffs()
      |> Enum.reduce({0, 0}, fn diff, {num_ones, num_threes} ->
        case diff do
          1 -> {num_ones + 1, num_threes}
          3 -> {num_ones, num_threes + 1}
          _ -> {num_ones, num_threes}
        end
      end)

    "#{num_ones} * #{num_threes} = #{num_ones * num_threes}"
  end

  @doc """
  iex> Aoc.Day10.part2()
  296196766695424
  """
  def part2(filename \\ "input10.txt") do
    path_map =
      filename
      |> get_lines()
      |> Enum.map(&String.to_integer/1)
      |> add_final_device_joltage()
      |> Kernel.++([0])
      |> Enum.sort(:desc)
      |> build_path_map(%{})

    {:ok, memo_agent} = Agent.start_link fn -> %{} end
    count_distinct_paths(path_map, Enum.max(Map.keys(path_map)), memo_agent)
  end

  def add_final_device_joltage(list) do
    list ++ [Enum.max(list) + 3]
  end

  def calculate_jolt_diffs(adapters, look_back \\ [0], diffs \\ [])

  def calculate_jolt_diffs([head | tail], [prev | _] = look_back, diffs) do
    case head - prev do
      n when n in 1..3 -> calculate_jolt_diffs(tail, [head | look_back], [n | diffs])
      _ -> :error
    end
  end

  def calculate_jolt_diffs([], _, diffs), do: Enum.reverse(diffs)

  def build_path_map([head, next, next_next, next_next_next | tail], path_map) do
    case {head - next, head - next_next, head - next_next_next} do
      {1, 2, 3} ->
        build_path_map(
          [next, next_next, next_next_next] ++ tail,
          Map.put(path_map, head, [next, next_next, next_next_next])
        )

      {n, m, _} when n in 1..3 and m in 1..3 ->
        build_path_map(
          [next, next_next, next_next_next] ++ tail,
          Map.put(path_map, head, [next, next_next])
        )

      {n, _, _} when n in 1..3 ->
        build_path_map([next, next_next, next_next_next] ++ tail, Map.put(path_map, head, [next]))

      _ ->
        throw(:bad_input)
    end
  end

  def build_path_map([head, next, next_next], path_map) do
    case {head - next, head - next_next} do
      {n, m} when n in 1..3 and m in 1..3 ->
        build_path_map([next, next_next], Map.put(path_map, head, [next, next_next]))

      {n, _} when n in 1..3 ->
        build_path_map([next, next_next], Map.put(path_map, head, [next]))

      _ ->
        throw(:bad_input)
    end
  end

  def build_path_map([head, next], path_map), do: Map.put(path_map, head, [next])

  def count_distinct_paths(_, 0, _), do: 1

  def count_distinct_paths(path_map, cur_key, memo_agent) do
    case Agent.get(memo_agent, &(Map.get(&1, cur_key))) do
      nil ->
        sum = path_map
        |> Map.get(cur_key)
        |> Enum.map(&(count_distinct_paths(path_map, &1, memo_agent)))
        |> Enum.sum()
        Agent.update(memo_agent, fn map -> Map.put(map, cur_key, sum) end)
        sum

      n ->
        n
    end
  end
end
