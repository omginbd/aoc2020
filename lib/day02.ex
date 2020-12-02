defmodule Aoc.Day02 do
  import Aoc.Utils

  def part1(filename) do
    get_lines(filename)
    |> check_passwords()
  end

  defp check_passwords(list, count \\ 0)

  defp check_passwords([head | tail], count) do
    [_, min, max, letter, password] = Regex.run(~r/(\d+)\-(\d+) (\w)\: (\w+)/, head)
    num_letters = Map.get(Enum.frequencies(String.codepoints(password)), letter)

    if num_letters >= String.to_integer(min) and num_letters <= String.to_integer(max) do
      check_passwords(tail, count + 1)
    else
      check_passwords(tail, count)
    end
  end

  defp check_passwords([], count), do: count

  def part2(filename) do
    get_lines(filename)
    |> check_passwords_positions
  end

  defp check_passwords_positions(list, count \\ 0)

  defp check_passwords_positions([head | tail], count) do
    [_, pos1, pos2, letter, password] = Regex.run(~r/(\d+)\-(\d+) (\w)\: (\w+)/, head)

    # Adjust for 1 index
    pos1 = String.to_integer(pos1) - 1
    pos2 = String.to_integer(pos2) - 1

    password_letters = String.codepoints(password)
    let1 = Enum.at(password_letters, pos1)
    let2 = Enum.at(password_letters, pos2)

    if (let1 === letter and let2 !== letter) or (let1 !== letter and let2 === letter) do
      check_passwords_positions(tail, count + 1)
    else
      check_passwords_positions(tail, count)
    end
  end

  defp check_passwords_positions([], count), do: count
end
