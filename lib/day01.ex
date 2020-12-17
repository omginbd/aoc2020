defmodule Aoc.Day01 do
  import Aoc.Utils

  def part1(filename) do
    {first, second} =
      filename
      |> get_lines
      |> Enum.map(&String.to_integer/1)
      |> find_summing_numbers(2020)

    first * second
  end

  defp find_summing_numbers([head | tail], number_to_find) do
    other_number = Enum.find(tail, fn a -> a === number_to_find - head end)

    case other_number do
      nil -> find_summing_numbers(tail, number_to_find)
      _ -> {head, other_number}
    end
  end

  defp find_summing_numbers([], _num), do: nil

  @doc """
  iex> Aoc.Day01.part2
  276912720
  """
  def part2(filename \\ "input01.txt") do
    {first, {second, third}} =
      filename
      |> get_lines
      |> Enum.map(&String.to_integer/1)
      |> find_three_summing_numbers(2020)

    first * second * third
  end

  defp find_three_summing_numbers([head | tail], number_to_find) do
    other_numbers = find_summing_numbers(tail, number_to_find - head)

    case other_numbers do
      nil -> find_three_summing_numbers(tail, number_to_find)
      _ -> {head, other_numbers}
    end
  end
end
