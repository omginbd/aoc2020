defmodule Aoc.Utils do
  def read_file(filename) do
    File.read!(filename)
  end

  def get_lines(filename) do
    filename
    |> File.read!
    |> String.split("\n")
  end
end
