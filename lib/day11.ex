defmodule Aoc.Day11 do
  import Aoc.Utils

  @doc """
  iex> Aoc.Day11.part1
  2263
  """
  def part1(filename \\ "input11.txt") do
    filename
    |> get_lines()
    |> build_seat_map()
    |> iterate_til_stable()
    |> Map.values()
    |> Enum.count(&(&1 === "#"))
  end

  @doc """
  # iex> Aoc.Day11.part2
  # 2002
  """
  def part2(filename \\ "input11.txt") do
    seat_map =
      filename
      |> get_lines()
      |> build_seat_map()

    neighbor_map =
      seat_map
      |> Map.keys()
      |> Enum.reduce(%{}, fn coords, acc ->
        Map.put(acc, coords, get_visible_neighbors(coords, seat_map))
      end)

    {seat_map, neighbor_map}
    |> iterate_til_stable_2()
    |> Map.values()
    |> Enum.count(&(&1 === "#"))
  end

  @doc """
  iex> [".L", "L."] |> Aoc.Day11.build_seat_map
  %{{0, 0} => ".", {0, 1} => "L", {1, 0} => "L", {1, 1} => "."}
  """
  def build_seat_map(lines, row \\ 0, seat_map \\ %{})

  def build_seat_map([head | tail], row, seat_map) do
    row_map =
      head
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {char, col}, acc -> Map.put(acc, {row, col}, char) end)

    build_seat_map(tail, row + 1, Map.merge(seat_map, row_map))
  end

  def build_seat_map([], _, seat_map), do: seat_map

  def iterate_til_stable(seat_map, iteration \\ 0)

  def iterate_til_stable(seat_map, iteration) do
    {changed_cells, new_seat_map} = tick(seat_map)

    case Enum.count(changed_cells) do
      0 -> new_seat_map
      _ -> iterate_til_stable(new_seat_map, iteration + 1)
    end
  end

  def tick(old_seat_map) do
    old_seat_map
    |> Map.keys()
    |> Enum.reduce({[], %{}}, fn coords, {changed_coords, new_seat_map} ->
      new_val = eval_seat(Map.get(old_seat_map, coords), get_neighbors(coords, old_seat_map))

      if new_val === Map.get(old_seat_map, coords),
        do: {changed_coords, Map.put(new_seat_map, coords, new_val)},
        else: {[coords | changed_coords], Map.put(new_seat_map, coords, new_val)}
    end)
  end

  def pretty_print(seat_map) do
    num_rows =
      seat_map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    num_cols =
      seat_map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.max()

    for x <- 0..num_cols do
      for y <- 0..num_rows do
        Map.get(seat_map, {x, y})
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def eval_seat(letter, neighbors, opts \\ 4)
  def eval_seat(".", _, _), do: "."

  def eval_seat("L", neighbors, _) do
    neighbors
    |> Enum.count(&(&1 === "#"))
    |> case do
      0 -> "#"
      _ -> "L"
    end
  end

  def eval_seat("#", neighbors, num_neigbors_to_leave) do
    neighbors
    |> Enum.count(&(&1 === "#"))
    |> case do
      n when n >= num_neigbors_to_leave -> "L"
      _ -> "#"
    end
  end

  @doc """
  iex> Aoc.Day11.get_neighbors({0, 0}, ["LL", "LL"] |> Aoc.Day11.build_seat_map)
  [".", ".", ".", ".", ".", "L", ".", "L", "L"]
  """
  def get_neighbors({row, col}, seat_map) do
    for r <- (row - 1)..(row + 1),
        c <- (col - 1)..(col + 1),
        do: if(r === row and c === col, do: ".", else: Map.get(seat_map, {r, c}, "."))
  end

  def iterate_til_stable_2({seat_map, neighbor_map}) do
    {changed_cells, new_seat_map} = tick_2(seat_map, neighbor_map)

    case Enum.count(changed_cells) do
      0 -> new_seat_map
      _ -> iterate_til_stable_2({new_seat_map, neighbor_map})
    end
  end

  def tick_2(old_seat_map, neighbor_map) do
    old_seat_map
    |> Map.keys()
    |> Enum.reduce({[], %{}}, fn coords, {changed_coords, new_seat_map} ->
      if Map.get(old_seat_map, coords) === "." do
        {changed_coords, Map.put(new_seat_map, coords, ".")}
      else
        neighbors =
          Map.get(neighbor_map, coords)
          |> Enum.map(&Map.get(old_seat_map, &1))

        new_val = eval_seat(Map.get(old_seat_map, coords), neighbors, 5)

        if new_val === Map.get(old_seat_map, coords),
          do: {changed_coords, Map.put(new_seat_map, coords, new_val)},
          else: {[coords | changed_coords], Map.put(new_seat_map, coords, new_val)}
      end
    end)
  end

  def get_visible_neighbors({row, col}, seat_map) do
    num_cols =
      seat_map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    num_rows =
      seat_map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.max()

    for dx <- -1..1, dy <- -1..1, {dx, dy} !== {0, 0} do
      find_nearest_neighbor_in_direction(
        seat_map,
        {row + dy, col + dx},
        {dx, dy},
        num_rows,
        num_cols
      )
    end
    |> Enum.filter(&(&1 !== nil))
  end

  def find_nearest_neighbor_in_direction(_, {row, col}, _, num_rows, num_cols)
      when row not in 0..num_rows or col not in 0..num_cols,
      do: nil

  def find_nearest_neighbor_in_direction(seat_map, {row, col}, {dx, dy}, num_rows, num_cols) do
    case Map.get(seat_map, {row, col}) do
      "." ->
        find_nearest_neighbor_in_direction(
          seat_map,
          {row + dy, col + dx},
          {dx, dy},
          num_rows,
          num_cols
        )

      _ ->
        {row, col}
    end
  end
end
