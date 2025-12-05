defmodule Cafeteria do
  def run(file) do
    file
    |> read_file()
    |> process_input()
    |> find_fresh_ingredients()
  end

  defp read_file(file) do
    file
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end

  defp process_input([ranges, ingredients]) do
    %{
      ranges: process_ranges(ranges),
      ingredients: process_ingredients(ingredients)
    }
  end

  defp process_ranges(ranges) do
    ranges
    |> String.split("\n", trim: true)
    |> Enum.map(&process_range_line/1)
  end

  defp process_range_line(range) do
    range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  defp process_ingredients(ingredients) do
    ingredients
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp find_fresh_ingredients(data) do
    %{ranges: ranges, ingredients: ingredients} = data

    Enum.reduce(ingredients, 0, fn i, acc ->
      if Enum.any?(ranges, fn [a, b] -> a <= i && i <= b end) do
        acc + 1
      else
        acc
      end
    end)
  end
end

IO.inspect(Cafeteria.run("input.txt"))
