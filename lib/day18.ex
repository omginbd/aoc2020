defmodule Aoc.Day18 do
  import Aoc.Utils

  def parse(filename) do
    filename
    |> get_lines()
    |> Enum.map(&(String.replace(&1, " ", "")))
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn char ->
        case Integer.parse(char) do
          {x, ""} -> x
          :error -> char
        end
      end)
    end)
  end

  def to_postfix(expr, stack \\ [], result \\ [])
  def to_postfix([head | tail], stack, result) when is_number(head) do
    to_postfix(tail, stack, [head | result])
  end

  def to_postfix([head | tail], [], result) do
    to_postfix(tail, [head], result)
  end

  def to_postfix(["(" | tail], stack, result) do
    to_postfix(tail, ["(" | stack], result)
  end

  def to_postfix(["*" | tail], [ "+" | stack_tail], result) do
    to_postfix(tail, ["*" | stack_tail], ["+" | result])
  end

  def to_postfix(["*" | tail], stack, result) do
    to_postfix(tail, ["*" | stack], result)
  end

  def to_postfix(["+" | tail], ["+" | stack_tail], result) do
    to_postfix(tail, ["+" | stack_tail], ["+" | result])
  end

  def to_postfix(["+" | tail], stack, result) do
    to_postfix(tail, ["+" | stack], result)
  end

  def to_postfix([")" | tail], stack, result) do
    {to_pop, new_stack} = Enum.split_while(stack, &(&1 !== "("))
    to_postfix(tail, tl(new_stack), Enum.reverse(to_pop) ++ result)
  end

  def to_postfix([], stack, result), do: Enum.reverse(result, stack)

  def part1(filename \\ "input18.txt") do
    filename
    |> parse()
    |> Enum.map(&(evaluate_expression(&1)))
    |> Enum.sum()
  end

  def part2(filename \\ "input18.txt") do
    filename
    |> parse()
    |> Enum.map(&(to_postfix(&1)))
    |> Enum.map(&(evaluate_postfix_expression(&1)))
    |> Enum.sum
  end

  def evaluate_expression(["(" | tail]) do
    {sub_expr, rest} = evaluate_expression(tail)
    evaluate_expression([sub_expr | rest])
  end
  def evaluate_expression([head, operand, "(" | tail]) do
    {sub_expr, rest} = evaluate_expression(tail)
    evaluate_expression([head, operand, sub_expr | rest])
  end

  def evaluate_expression([head, ")" | tail]), do: {head, tail}

  def evaluate_expression([right_operand, "*", left_operand | tail]) when is_integer(right_operand) and is_integer(left_operand) do
    evaluate_expression([left_operand * right_operand | tail])
  end

  def evaluate_expression([right_operand, "+", left_operand | tail]) when is_integer(right_operand) and is_integer(left_operand) do
    evaluate_expression([left_operand + right_operand | tail])
  end

  def evaluate_expression([result]), do: result

  def evaluate_postfix_expression(expr, stack \\ [])
  def evaluate_postfix_expression([head | tail], stack) when is_number(head), do: evaluate_postfix_expression(tail, [head | stack])
  def evaluate_postfix_expression(["*" | tail], [op1, op2 | stack_tail]) do
    evaluate_postfix_expression(tail, [op1 * op2 | stack_tail])
  end
  def evaluate_postfix_expression(["+" | tail], [op1, op2 | stack_tail]) do
    evaluate_postfix_expression(tail, [op1 + op2 | stack_tail])
  end

  def evaluate_postfix_expression([], [result]), do: result
end
