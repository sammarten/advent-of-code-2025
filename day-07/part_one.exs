defmodule Laboratories do
  def run(file) do
    file
    |> read_file()
    |> find_split_count()
  end

  defp read_file(file) do
    [start | lines] =
      file
      |> File.read!()
      |> String.split("\n", trim: true)

    %{
      beam_index: find_beam_index(start),
      lines: process_lines(lines)
    }
  end

  defp find_beam_index(start) do
    start
    |> String.split("", trim: true)
    |> Enum.find_index(fn s -> s == "S" end)
  end

  defp process_lines(lines) do
    Enum.map(lines, &String.split(&1, "", trim: true))
  end

  defp find_split_count(data) do
    %{beam_index: beam_index, lines: lines} = data

    lines
    |> Enum.reduce(%{beams: [beam_index], num_splits: 0}, &process_line/2)
    |> Map.get(:num_splits)
  end

  defp process_line(line, acc) do
    Enum.reduce(acc.beams, %{beams: [], num_splits: acc.num_splits}, &process_beam(&1, line, &2))
  end

  defp process_beam(beam, line, acc) do
    if Enum.at(line, beam) == "^" do
      %{beams: Enum.uniq([(beam - 1), (beam + 1)] ++ acc.beams), num_splits: acc.num_splits + 1}
    else
      %{acc | beams: [beam | acc.beams]}
    end
  end
end

IO.inspect(Laboratories.run("input.txt"))
