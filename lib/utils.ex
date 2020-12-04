defmodule Aoc.Utils do
  def read_file(filename) do
    File.read!(filename)
  end

  def get_lines(filename, split_char \\ "\n")
  def get_lines(filename, split_char) do
    filename
    |> File.read!
    |> String.split(split_char)
  end
end
