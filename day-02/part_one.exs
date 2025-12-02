defmodule GiftShop do
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
    value = to_string(value)
    length = String.length(value)

    if rem(length, 2) == 0, do: check_for_repeat(value, div(length, 2)), else: false
  end

  defp check_for_repeat(value, half_length) do
    {a, b} = String.split_at(value, half_length)
    a == b
  end
end

IO.inspect(GiftShop.run("input.txt"))
