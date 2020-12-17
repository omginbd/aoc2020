defmodule Aoc.Day16 do
  import Aoc.Utils

  def parse(filename) do
    [fields_block, my_ticket_block, other_tickets_block] =
      filename
      |> get_lines("\n\n")

    ranges =
      fields_block
      |> String.split("\n")
      |> Enum.map(fn line ->
        [_, field_name, start1, end1, start2, end2] =
          Regex.run(~r/([\w|\s]+): (\d+)-(\d+) or (\d+)-(\d+)/, line)

        {field_name, String.to_integer(start1)..String.to_integer(end1),
         String.to_integer(start2)..String.to_integer(end2)}
      end)

    my_ticket =
      my_ticket_block
      |> String.split("\n")
      |> Enum.at(1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    other_tickets =
      other_tickets_block
      |> String.split("\n")
      |> Enum.drop(1)
      |> Enum.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)

    {ranges, my_ticket, other_tickets}
  end

  @doc """
  iex> part1()
  23925
  """
  def part1(filename \\ "input16.txt") do
    {fields, _, other_tickets} =
      filename
      |> parse()

    all_ranges =
      fields
      |> Enum.flat_map(&[elem(&1, 1), elem(&1, 2)])

    other_tickets
    |> Enum.flat_map(fn ticket ->
      Enum.filter(ticket, fn val -> not Enum.any?(all_ranges, &(val in &1)) end)
    end)
    |> Enum.sum()
  end

  @doc """
  iex> part2()
  964373157673
  """
  def part2(filename \\ "input16.txt") do
    {fields, my_ticket, other_tickets} =
      filename
      |> parse()

    all_ranges =
      fields
      |> Enum.flat_map(&[elem(&1, 1), elem(&1, 2)])

    valid_tickets =
      other_tickets
      |> Enum.filter(&filter_invalid_ticket(&1, all_ranges))

    possible_field_positions = for i <- 0..(Enum.count(my_ticket) - 1), into: %{}, do: {i, fields}

    find_field_positions(valid_tickets, possible_field_positions)
    |> Enum.filter(&String.contains?(elem(&1, 0), "departure"))
    |> Enum.map(fn {_, i} -> Enum.at(my_ticket, i) end)
    |> Enum.scan(&Kernel.*/2)
    |> List.last()
  end

  def filter_invalid_ticket(ticket, ranges) do
    not Enum.any?(ticket, fn val -> not Enum.any?(ranges, &(val in &1)) end)
  end

  def find_field_positions([head | tail], possible_field_positions) do
    new_possible_field_positions =
      head
      |> Enum.with_index()
      |> Enum.reduce(possible_field_positions, fn {num, i}, acc ->
        Map.update(acc, i, [], fn possible_fields_for_position ->
          Enum.filter(possible_fields_for_position, fn {_, r1, r2} -> num in r1 or num in r2 end)
        end)
      end)

    find_field_positions(tail, new_possible_field_positions)
  end

  def find_field_positions([], field_positions) do
    key_order =
      field_positions
      |> Map.keys()
      |> Enum.sort_by(&(Map.get(field_positions, &1) |> Enum.count()))

    key_order
    |> Enum.map(fn key -> Map.get(field_positions, key) |> Enum.map(&elem(&1, 0)) end)
    |> Enum.reduce([], fn possible_fields, acc ->
      [Enum.find(possible_fields, &(&1 not in acc)) | acc]
    end)
    |> Enum.reverse()
    |> Enum.zip(key_order)
    |> Enum.sort_by(&elem(&1, 0))
  end
end
