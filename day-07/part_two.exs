defmodule Laboratories do
  def run(file) do
    file
    |> read_file()
    |> calc_timeline_count()
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
    lines
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index()
  end

  # DFS
  defp calc_timeline_count(%{beam_index: beam_index, lines: lines}) do
    {timelines, _} = trace_beam_path(beam_index, lines, %{})
    timelines
  end

  defp trace_beam_path(_, [], lookup), do: {1, lookup}

  defp trace_beam_path(index, [{line, line_index} | lines], lookup) do
    if Enum.at(line, index) == "^" do
      case Map.get(lookup, {line_index, index}) do
        timelines when is_integer(timelines) ->
          {timelines, lookup}

        nil ->
          {left_total, updated_lookup} = trace_beam_path(index - 1, lines, lookup)
          {right_total, updated_lookup} = trace_beam_path(index + 1, lines, updated_lookup)
          timelines = right_total + left_total
          {timelines, Map.put(updated_lookup, {line_index, index}, timelines)}
      end
    else
      trace_beam_path(index, lines, lookup)
    end
  end
end

IO.inspect(Laboratories.run("input.txt"))
