defmodule Aoc.Day08 do
  import Aoc.Utils

  def part1(filename \\ "input08.txt") do
    filename
    |> get_lines()
    |> build_program_map()
    |> execute_til_loop
  end

  def part2(filename \\ "input08.txt") do
    filename
    |> get_lines()
    |> build_program_map()
    |> find_broken_instruction
  end

  def build_program_map(boot_code, program_map \\ %{}, line_number \\ 0)

  def build_program_map([head | tail], program_map, line_number) do
    case String.split(head, " ") do
      ["acc", n] ->
        build_program_map(
          tail,
          Map.put(program_map, line_number, {:acc, String.to_integer(n)}),
          line_number + 1
        )

      ["jmp", n] ->
        build_program_map(
          tail,
          Map.put(program_map, line_number, {:jmp, String.to_integer(n)}),
          line_number + 1
        )

      ["nop", n] ->
        build_program_map(
          tail,
          Map.put(program_map, line_number, {:nop, String.to_integer(n)}),
          line_number + 1
        )
    end
  end

  def build_program_map([], program_map, _), do: program_map

  def execute_til_loop(program_map, cur_line \\ 0, executed_lines \\ [], acc \\ 0)

  def execute_til_loop(program_map, cur_line, executed_lines, acc) do
    if Enum.member?(executed_lines, cur_line) do
      {:loop, acc}
    else
      new_executed_lines = [cur_line | executed_lines]

      case Map.get(program_map, cur_line) do
        {:acc, n} -> execute_til_loop(program_map, cur_line + 1, new_executed_lines, acc + n)
        {:jmp, n} -> execute_til_loop(program_map, cur_line + n, new_executed_lines, acc)
        {:nop, _} -> execute_til_loop(program_map, cur_line + 1, new_executed_lines, acc)
        _ -> {:exit, acc}
      end
    end
  end

  def find_broken_instruction(program_map) do
    lines_to_swap =
      program_map
      |> Map.keys()
      |> Enum.filter(fn key ->
        {op, _} = Map.get(program_map, key)
        Enum.member?([:nop, :jmp], op)
      end)

    test_lines(lines_to_swap, program_map)
  end

  def test_lines([head | tail], program_map) do
    case execute_til_loop(swap_jmp_nop(head, program_map)) do
      {:loop, _} -> test_lines(tail, program_map)
      {:exit, acc} -> acc
    end
  end

  def test_lines([], _), do: :no_fix_found

  def swap_jmp_nop(key, program_map) do
    case Map.get(program_map, key) do
      {:jmp, n} -> Map.put(program_map, key, {:nop, n})
      {:nop, n} -> Map.put(program_map, key, {:jmp, n})
    end
  end
end
