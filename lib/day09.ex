defmodule Aoc.Day09 do
  import Aoc.Utils

  def part1(filename \\ "input09.txt", preamble_size \\ 25) do
    {preamble, tape} =
      filename
      |> get_lines()
      |> Enum.map(&String.to_integer/1)
      |> Enum.split(preamble_size)

    find_first_invalid_number(preamble, tape)
  end

  def part2(filename \\ "input09.txt", preamble_size \\ 25) do
    {preamble, tape} =
      filename
      |> get_lines()
      |> Enum.map(&String.to_integer/1)
      |> Enum.split(preamble_size)

    find_first_invalid_number(preamble, tape)
    |> find_contiguous_summing_numbers(preamble ++ tape)
  end

  def find_first_invalid_number([p_head | p_tail], [head | tail]) do
    case find_summing_numbers([p_head | p_tail], head) do
      nil -> head
      _ -> find_first_invalid_number(p_tail ++ [head], tail)
    end
  end

  defp find_summing_numbers([head | tail], number_to_find) do
    other_number = Enum.find(tail, fn a -> a === number_to_find - head end)

    case other_number do
      nil -> find_summing_numbers(tail, number_to_find)
      _ -> {head, other_number}
    end
  end

  defp find_summing_numbers([], _num), do: nil

  def find_contiguous_summing_numbers(num_to_find, [head | tail]) do
    case test_start([head], tail, num_to_find) do
      nil -> find_contiguous_summing_numbers(num_to_find, tail)
      range -> Enum.min(range) + Enum.max(range)
    end
  end

  def test_start(numbers, [head | tail], num_to_find) do
    new_numbers = [head | numbers]

    case Enum.sum(new_numbers) do
      n when n > num_to_find -> nil
      n when n < num_to_find -> test_start(new_numbers, tail, num_to_find)
      n when n === num_to_find -> new_numbers
    end
  end
end
