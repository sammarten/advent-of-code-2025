defmodule Lobby do
  def run(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&find_max_joltage/1)
    |> Enum.sum()
  end

  defp find_max_joltage(chars) do
    first_digit =
      chars
      |> Enum.slice(0..-2//1)
      |> Enum.max()

    first_digit_index = Enum.find_index(chars, fn c -> c == first_digit end)

    second_digit =
      chars
      |> Enum.slice((first_digit_index + 1)..-1//1)
      |> Enum.max()

    String.to_integer((first_digit <> second_digit))
  end
end

IO.inspect(Lobby.run("input.txt"))
