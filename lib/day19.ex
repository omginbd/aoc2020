defmodule Aoc.Day19 do
  import Aoc.Utils

  def parse(filename) do
    [rule_lines, message_lines] =
      filename
      |> get_lines("\n\n")

    rule_map =
      rule_lines
      |> String.split("\n", trim: true)
      |> Enum.map(fn rule ->
        [_, rule_num, rule_components] = Regex.run(~r/(\d+): (.*)$/, rule)
        {rule_num, rule_components}
      end)
      |> Enum.reduce(%{}, &Map.put(&2, elem(&1, 0), elem(&1, 1)))

    messages =
      message_lines
      |> String.split("\n", trim: true)

    {rule_map, messages}
  end

  def part1(filename \\ "input19.txt") do
    {rule_map, messages} =
      filename
      |> parse()

    rule_zero_regex_string =
      rule_map
      |> compile_regex_for_key("0")

    rule_zero_regex =
      "^#{rule_zero_regex_string}$"
      |> Regex.compile!()
      |> IO.inspect()

    Enum.filter(messages, &Regex.match?(rule_zero_regex, &1))
    |> Enum.count()
  end

  def part2(filename \\ "input19.txt", visualize \\ false) do
    {rule_map, messages} =
      filename
      |> parse()

    rule_map_p2 = rule_map |> Map.put("8", "42 | 42 8") |> Map.put("11", "42 31 | 42 11 31")

    rule_zero_regex_string =
      rule_map_p2
      |> compile_regex_for_key("0", true)

    rule_zero_regex =
      "^#{rule_zero_regex_string}$"
      |> Regex.compile!()

    if visualize do
      messages
      |> Enum.map(&{Regex.match?(rule_zero_regex, &1), &1})
      |> Enum.map(fn {is_match, string} ->
        if is_match do
          IO.ANSI.green() <> string
        else
          IO.ANSI.red() <> string
        end
      end)
      |> Enum.each(&IO.puts/1)
    end

    Enum.filter(messages, &Regex.match?(rule_zero_regex, &1))
    |> Enum.count()
  end

  def compile_regex_for_key(rule_map, key \\ "0", doing_p2 \\ false)
  def compile_regex_for_key(_, "\"a\"", _), do: "a"
  def compile_regex_for_key(_, "\"b\"", _), do: "b"
  def compile_regex_for_key(_, "|", _), do: "|"

  def compile_regex_for_key(rule_map, "8", true) do
    "(#{
      rule_map
      |> Map.get("42")
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, true))
    })+"
  end

  def compile_regex_for_key(rule_map, "11", true) do
    ident = "a#{:rand.uniform(1000) |> Integer.to_string()}"

    "(?'#{ident}'(#{
      rule_map
      |> Map.get("42")
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, true))
    })(?&#{ident})?(#{
      rule_map
      |> Map.get("31")
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, true))
    }))"
  end

  def compile_regex_for_key(rule_map, key, is_p2?) do
    rule =
      rule_map
      |> Map.get(key)
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, is_p2?))

    case Enum.count(rule) do
      1 -> hd(rule)
      _ -> "(#{rule})"
    end
  end
end
