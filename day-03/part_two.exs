defmodule Lobby do
  def run(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&find_max_joltage/1)
    |> Enum.map(&Map.get(&1, :joltage))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp find_max_joltage(chars) do
    # this gets more complicated because you need to use the
    # selected value's indexes for the ranges
    # really for the first value of the range
    chars_with_index = Enum.with_index(chars)

    Enum.reduce(1..12, %{joltage: "", start_index: 0}, fn i, acc ->
      {digit, digit_index} =
        chars_with_index
        |> Enum.slice(acc.start_index..(-13 + i)//1)
        |> Enum.max_by(fn {c, _} -> c end)

      %{joltage: acc.joltage <> digit, start_index: digit_index + 1}
    end)
  end
end

IO.inspect(Lobby.run("input.txt"))
