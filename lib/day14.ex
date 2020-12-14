defmodule Aoc.Day14 do
  import Aoc.Utils

  @doc """
  iex> part1()
  7997531787333
  """
  def part1(filename \\ "input14.txt") do
    filename
    |> get_lines()
    |> Enum.map(fn line ->
      case Regex.run(~r/mask = ([X|1|0]+)/, line) do
        [_, mask] ->
          {:mask, mask}

        nil ->
          [_, mem_pos, val] = Regex.run(~r/mem\[(\d+)\] = (\d+)/, line)
          {:mem, String.to_integer(mem_pos), String.to_integer(val) |> Integer.to_string(2)}
      end
    end)
    |> init_memory
    |> Map.values()
    |> Enum.sum()
  end

  @doc """
  iex> part2()
  3564822193820
  """
  def part2(filename \\ "input14.txt") do
    filename
    |> get_lines()
    |> Enum.map(fn line ->
      case Regex.run(~r/mask = ([X|1|0]+)/, line) do
        [_, mask] ->
          {:mask, mask}

        nil ->
          [_, mem_pos, val] = Regex.run(~r/mem\[(\d+)\] = (\d+)/, line)
          {:mem, String.to_integer(mem_pos), String.to_integer(val)}
      end
    end)
    |> init_memory_v2
    |> Map.values()
    |> Enum.sum()
  end

  def init_memory(commands, mask \\ "", memory \\ %{})
  def init_memory([{:mask, mask} | tail], _, memory), do: init_memory(tail, mask, memory)

  def init_memory([{:mem, mem_pos, val} | tail], mask, memory) do
    init_memory(tail, mask, Map.put(memory, mem_pos, mask_value(mask, val)))
  end

  def init_memory([], _, memory), do: memory

  def mask_value(mask, value) do
    value
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Stream.zip(String.graphemes(mask))
    |> Stream.map(fn {bit, mask_bit} ->
      case mask_bit do
        "X" -> bit
        _ -> mask_bit
      end
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def init_memory_v2(commands, mask \\ "", memory \\ %{})
  def init_memory_v2([{:mask, mask} | tail], _, memory), do: init_memory_v2(tail, mask, memory)

  def init_memory_v2([{:mem, mem_pos, val} | tail], mask, memory) do
    memory_adresses_to_write = get_memory_addresses(mem_pos, mask)

    init_memory_v2(
      tail,
      mask,
      Enum.reduce(memory_adresses_to_write, memory, &Map.put(&2, &1, val))
    )
  end

  def init_memory_v2([], _, memory), do: memory

  def get_memory_addresses(mem_pos, mask) do
    {base_val, x_pos_list} =
      mem_pos
      |> Integer.to_string(2)
      |> String.pad_leading(36, "0")
      |> String.graphemes()
      |> Stream.zip(String.graphemes(mask))
      |> Stream.map(fn {bit, mask_bit} ->
        case mask_bit do
          "0" -> bit
          _ -> mask_bit
        end
      end)
      |> Stream.with_index()
      |> Enum.reduce({"", []}, fn {bit, i}, {string_so_far, x_pos_list} ->
        case bit do
          "X" -> {string_so_far <> "0", [35 - i | x_pos_list]}
          _ -> {string_so_far <> bit, x_pos_list}
        end
      end)

    base_val = base_val |> String.to_integer(2)

    x_pos_list
      |> Enum.map(&(:math.pow(2, &1) |> floor))
      |> get_permutations([0])
      |> Enum.map(&(base_val + &1))
  end

  def get_permutations([head | tail], list_so_far) do
    new_list = for a <- [0, head], b <- list_so_far, do: a + b
    get_permutations(tail, Enum.uniq(new_list))
  end
  def get_permutations([], list_so_far), do: list_so_far
end
