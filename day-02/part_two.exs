defmodule GiftShop do
  @pattern_lengths %{
    1 => [],
    2 => [1],
    3 => [1],
    4 => [1, 2],
    5 => [1],
    6 => [1, 2, 3],
    7 => [1],
    8 => [1, 2, 4],
    9 => [1, 3],
    10 => [1, 2, 5]
  }

  def run(file) do
    file
    |> File.read!()
    |> String.split(",", trim: true)
    |> Enum.map(&to_range/1)
    |> Enum.flat_map(&find_invalid_codes/1)
    |> Enum.sum()
  end

  def to_range(range_string) do
    [start, stop] =
      range_string
      |> String.split("-", trim: true)
      |> Enum.map(&String.to_integer/1)

    Range.new(start, stop)
  end

  def find_invalid_codes(range) do
    range
    |> Enum.to_list()
    |> Enum.filter(&is_invalid/1)
  end

  defp is_invalid(value) do
    values =
      value
      |> to_string()
      |> String.graphemes()

    length = Enum.count(values)

    @pattern_lengths
    |> Map.get(length)
    |> Enum.any?(&repeats?(&1, values))
  end

  defp repeats?(length, values) do
    [f | rem] = Enum.chunk_every(values, length)

    Enum.all?(rem, fn r -> r == f end)
  end
end

IO.inspect(GiftShop.run("input.txt"))
