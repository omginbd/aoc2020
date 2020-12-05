defmodule Aoc.Day05 do
  import Aoc.Utils

  def part1(filename \\ "input05.txt") do
    filename
    |> get_lines()
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&bsp_to_seat_id/1)
    |> Enum.max()
  end

  def part2(filename \\ "input05.txt") do
    filename
    |> get_lines()
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&bsp_to_seat_id/1)
    |> Enum.sort()
    |> find_missing_id
  end

  def find_missing_id([head, next | tail]) when next === head + 1,
    do: find_missing_id([next | tail])

  def find_missing_id([head, _ | _]), do: head + 1
  def find_missing_id(_), do: :no_missing_id_found

  def bsp_to_seat_id(chars, col_low \\ 1, col_high \\ 8, row_low \\ 1, row_high \\ 128)

  def bsp_to_seat_id(["F" | tail], col_low, col_high, row_low, row_high) do
    bsp_to_seat_id(
      tail,
      col_low,
      col_high,
      row_low,
      row_low + (row_high - row_low + 1) / 2 - 1
    )
  end

  def bsp_to_seat_id(["B" | tail], col_low, col_high, row_low, row_high) do
    bsp_to_seat_id(
      tail,
      col_low,
      col_high,
      row_high - (row_high - row_low + 1) / 2 + 1,
      row_high
    )
  end

  def bsp_to_seat_id(["R" | tail], col_low, col_high, row_low, row_high) do
    bsp_to_seat_id(
      tail,
      col_high - (col_high - col_low + 1) / 2 + 1,
      col_high,
      row_low,
      row_high
    )
  end

  def bsp_to_seat_id(["L" | tail], col_low, col_high, row_low, row_high) do
    bsp_to_seat_id(
      tail,
      col_low,
      col_low + (col_high - col_low + 1) / 2 - 1,
      row_low,
      row_high
    )
  end

  def bsp_to_seat_id([], col_low, _, row_low, _), do: get_seat_id({col_low - 1, row_low - 1})

  def get_seat_id({col, row}), do: row * 8 + col
end
