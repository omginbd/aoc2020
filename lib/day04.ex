defmodule Aoc.Day04 do
  import Aoc.Utils

  @necessary_attrs ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def part1(filename \\ "input04.txt") do
    filename
    |> get_lines("\n\n")
    |> Enum.map(&normalize_passport_whitespace/1)
    |> parse_passports()
  end

  def parse_passports(passports, num_valid \\ 0)

  def parse_passports([head | tail], num_valid) do
    passport_attrs =
      head
      |> String.split(" ")
      |> Enum.reduce(%{}, fn key_val, attrs ->
        [key, val] =
          key_val
          |> String.split(":")

        Map.put(attrs, key, val)
      end)
      |> Map.keys()

    missing_attrs = @necessary_attrs -- passport_attrs

    case length(missing_attrs) do
      0 -> parse_passports(tail, num_valid + 1)
      _ -> parse_passports(tail, num_valid)
    end
  end

  def parse_passports(_, num_valid), do: num_valid

  def normalize_passport_whitespace(passport_string),
    do: Regex.replace(~r/\s/, passport_string, " ")

  def part2(filename \\ "input04.txt") do
    filename
    |> get_lines("\n\n")
    |> Enum.map(&normalize_passport_whitespace/1)
    |> parse_and_validate_passports()
  end

  def parse_and_validate_passports(passports, num_valid \\ 0)

  def parse_and_validate_passports([head | tail], num_valid) do
    passport_attrs =
      head
      |> String.split(" ")
      |> Enum.reduce(%{}, fn key_val, attrs ->
        [key, val] =
          key_val
          |> String.split(":")
          |> parse_if_needed

        case is_valid?(key, val) do
          true -> Map.put(attrs, key, val)
          _ -> attrs
        end
      end)
      |> Map.keys()

    missing_attrs = @necessary_attrs -- passport_attrs

    case length(missing_attrs) do
      0 -> parse_and_validate_passports(tail, num_valid + 1)
      _ -> parse_and_validate_passports(tail, num_valid)
    end
  end

  def parse_and_validate_passports(_, num_valid), do: num_valid

  def is_valid?("byr", val) when val in 1920..2002, do: true
  def is_valid?("iyr", val) when val in 2010..2020, do: true
  def is_valid?("eyr", val) when val in 2020..2030, do: true

  def is_valid?("hgt", val) do
    case Integer.parse(val) do
      {num, "cm"} -> num in 150..193
      {num, "in"} -> num in 59..76
      _ -> false
    end
  end

  def is_valid?("hcl", val), do: Regex.match?(~r/\#[0-9a-f]{6}/, val)

  def is_valid?("ecl", val) when val in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
    do: true

  def is_valid?("pid", val) do
    case Integer.parse(val) do
      :error -> false
      {_, ""} -> String.length(val) === 9
      _ -> false
    end
  end

  def is_valid?("cid", _), do: true
  def is_valid?(_, _), do: false

  def parse_if_needed([key, val]) when key in ["byr", "iyr", "eyr"],
    do: [key, String.to_integer(val)]

  def parse_if_needed(args), do: args
end
