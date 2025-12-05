defmodule Cafeteria do
  def run(file) do
    file
    |> read_file()
    |> process_ranges()
    |> consolidate_ranges()
  end

  defp read_file(file) do
    file
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end

  defp process_ranges([ranges, _ingredients]) do
    ranges
    |> String.split("\n", trim: true)
    |> Enum.map(&process_range_line/1)
    |> Enum.sort_by(fn [r1, _] -> r1 end)
  end

  defp process_range_line(range) do
    range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  defp consolidate_ranges([r | ranges]) do
    %{ranges: combined_ranges, cur_range: cur_range} =
      Enum.reduce(ranges, %{ranges: [], cur_range: r}, &maybe_combine_ranges/2)

    [cur_range | combined_ranges]
    |> Enum.reduce(0, fn [r1, r2], acc -> acc + r2 - r1 + 1 end)
  end

  defp maybe_combine_ranges([b1, b2] = r, acc) do
    %{cur_range: [a1, a2]} = acc

    cond do
      a2 < b1 ->
        %{ranges: [[a1, a2] | acc.ranges], cur_range: r}

      true ->
        %{acc | cur_range: [a1, Enum.max([a2, b2])]}
    end
  end
end

IO.inspect(Cafeteria.run("input.txt"))
