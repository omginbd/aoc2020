# defmodule Aoc.Practice do
#   import Aoc.Utils

#   def part1(filename, required) do
#     filename
#     |> get_lines
#     |> get_reaction_table({%{}, []})
#     |> IO.inspect()
#     |> get_ore_required(required, 1, %{})
#   end

#   defp get_reaction_table([line | tail], {table, prime_elements}) do
#     [components, yield] = String.split(line, "=>") |> Enum.map(&String.trim/1)
#     [yield_amount, yield_element] = String.split(yield, " ")

#     requirements =
#       components
#       |> String.split(",")
#       |> Enum.map(fn component ->
#         [amount, element] =
#           component
#           |> String.trim()
#           |> String.split(" ")

#         {element, String.to_integer(amount)}
#       end)

#     new_table = Map.put(table, yield_element, {String.to_integer(yield_amount), requirements})
#     case requirements do
#       [{"ORE", _n}] -> get_reaction_table(tail, {new_table, [yield_element | prime_elements]})
#       _ -> get_reaction_table(tail, {new_table, prime_elements})
#     end
#   end

#   defp get_reaction_table([], returns), do: returns

#   def get_ore_required({reaction_table, prime_elements}, required_element, prime_element_quantities) do
#     {_, sub_elements} = Map.get(reaction_table, required_element)
#     Enum.map(sub_elements, fn {element, quantity} ->
#       if element in prime_elements do
#         Map.update(prime_element_quantities, element, 0, &(&1 + quantity))
#       end
#       get_ore_required()
#     end)
#     end

#   end

#   # %{
#   #   "FUEL" => {yield, [{"SUB_1", 4}, {"SUB_2"}, 6]}
#   # }
#   def get_ore_required(_reaction_table, "ORE", required_element_amount),
#     do: required_element_amount

#   def get_ore_required(reaction_table, required_element, required_element_amount) do
#     {yield, sub_elements} = Map.get(reaction_table, required_element)
#     IO.inspect({"sub_elements", sub_elements})

#     sub_elements
#     |> Enum.map(fn {element, amount} ->
#       get_ore_required(reaction_table, element, ceil(required_element_amount / yield) * amount)
#     end)
#     |> Enum.sum()
#   end
# end
