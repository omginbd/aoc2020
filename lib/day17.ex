defmodule Aoc.Day17 do
  import Aoc.Utils

  def parse(filename) do
    filename
    |> get_lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, acc ->
        Map.put(acc, {x, y, 0}, char)
      end)
    end)
  end

  def parse_4d(filename) do
    state_3d =
      filename
      |> parse

    for {{x, y, z}, cube_state} <- state_3d, into: %{}, do: {{x, y, z, 0}, cube_state}
  end

  def part1(filename \\ "input17.txt") do
    filename
    |> parse
    |> simulate(6)
    |> Map.values()
    |> Enum.count(&(&1 === "#"))
  end

  def part2(filename \\ "input17.txt") do
    filename
    |> parse_4d
    |> simulate_4d(6)
    |> Map.values()
    |> Enum.count(&(&1 === "#"))
  end

  def simulate(state, 0), do: state

  def simulate(state, cur_turn) do
    padded_state = pad_state(state)

    for {{x, y, z}, cube_state} <- padded_state, into: %{} do
      num_active_neighbors =
        get_neighbors({x, y, z}, padded_state)
        |> Enum.count(&(&1 === "#"))

      new_cube_state =
        cond do
          cube_state === "#" and num_active_neighbors in 2..3 -> "#"
          cube_state === "." and num_active_neighbors === 3 -> "#"
          true -> "."
        end

      {{x, y, z}, new_cube_state}
    end
    |> pretty_print()
    |> simulate(cur_turn - 1)
  end

  def pad_state(state) do
    {min_x, max_x} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {min_y, max_y} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    {min_z, max_z} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 2))
      |> Enum.min_max()

    t1 =
      for x <- (min_x - 1)..(max_x + 1),
          y <- [min_y - 1, max_y + 1],
          z <- (min_z - 1)..(max_z + 1),
          into: state do
        {{x, y, z}, "."}
      end

    t2 =
      for x <- [min_x - 1, max_x + 1],
          y <- min_y..max_y,
          z <- (min_z - 1)..(max_z + 1),
          into: t1 do
        {{x, y, z}, "."}
      end

    for x <- min_x..max_x,
        y <- min_y..max_y,
        z <- [min_z - 1, max_z + 1],
        into: t2 do
      {{x, y, z}, "."}
    end
  end

  def get_neighbors({x, y, z}, state) do
    for x_1 <- (x - 1)..(x + 1),
        y_1 <- (y - 1)..(y + 1),
        z_1 <- (z - 1)..(z + 1),
        do:
          if(x_1 === x and y_1 === y and z_1 === z,
            do: ".",
            else: Map.get(state, {x_1, y_1, z_1}, ".")
          )
  end

  def pretty_print(state) do
    {min_x, max_x} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {min_y, max_y} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    {min_z, max_z} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 2))
      |> Enum.min_max()

    for z <- min_z..max_z do
      IO.puts("z=#{z}")

      for y <- min_y..max_y do
        for x <- min_x..max_x do
          IO.write(Map.get(state, {x, y, z}))
        end

        IO.write("\n")
      end

      IO.write("\n\n")
    end

    state
  end

  def simulate_4d(state, 0), do: state

  def simulate_4d(state, cur_turn) do
    padded_state = pad_state_4d(state)

    for {{x, y, z, w}, cube_state} <- padded_state, into: %{} do
      num_active_neighbors =
        get_neighbors_4d({x, y, z, w}, padded_state)
        |> Enum.count(&(&1 === "#"))

      new_cube_state =
        cond do
          cube_state === "#" and num_active_neighbors in 2..3 -> "#"
          cube_state === "." and num_active_neighbors === 3 -> "#"
          true -> "."
        end

      {{x, y, z, w}, new_cube_state}
    end
    |> simulate_4d(cur_turn - 1)
  end

  def get_neighbors_4d({x, y, z, w}, state) do
    for x_1 <- (x - 1)..(x + 1),
        y_1 <- (y - 1)..(y + 1),
        z_1 <- (z - 1)..(z + 1),
        w_1 <- (w - 1)..(w + 1),
        do:
          if(x_1 === x and y_1 === y and z_1 === z and w_1 === w,
            do: ".",
            else: Map.get(state, {x_1, y_1, z_1, w_1}, ".")
          )
  end

  def pad_state_4d(state) do
    {min_x, max_x} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {min_y, max_y} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    {min_z, max_z} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 2))
      |> Enum.min_max()

    {min_w, max_w} =
      state
      |> Map.keys()
      |> Enum.map(&elem(&1, 3))
      |> Enum.min_max()

    t1 =
      for x <- (min_x - 1)..(max_x + 1),
          y <- [min_y - 1, max_y + 1],
          z <- (min_z - 1)..(max_z + 1),
          w <- min_w..max_w,
          into: state do
        {{x, y, z, w}, "."}
      end

    t2 =
      for x <- [min_x - 1, max_x + 1],
          y <- min_y..max_y,
          z <- (min_z - 1)..(max_z + 1),
          w <- min_w..max_w,
          into: t1 do
        {{x, y, z, w}, "."}
      end

    t3 =
      for x <- min_x..max_x,
          y <- min_y..max_y,
          z <- [min_z - 1, max_z + 1],
          w <- min_w..max_w,
          into: t2 do
        {{x, y, z, w}, "."}
      end

    for x <- (min_x - 1)..(max_x + 1),
        y <- (min_y - 1)..(max_y + 1),
        z <- (min_z - 1)..(max_z + 1),
        w <- [min_w - 1, max_w + 1],
        into: t3 do
      {{x, y, z, w}, "."}
    end
  end
end
