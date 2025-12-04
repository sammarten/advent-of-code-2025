defmodule PrintingDepartment do
  def run(file) do
    file
    |> create_grid()
    |> process_grid()
  end

  defp create_grid(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&row_to_grid/1)
    |> Enum.into(%{})
  end

  defp row_to_grid({data, row}) do
    data
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {d, col} -> {{row, col}, symbol_to_int(d)} end)
  end

  defp symbol_to_int("."), do: 0
  defp symbol_to_int("@"), do: 1

  defp process_grid(grid) do
    find_and_remove_rolls(grid, 0)
  end

  defp find_and_remove_rolls(grid, count) do
    rolls_to_remove = Enum.reduce(grid, [], &find_rolls_to_remove(&1, grid, &2))
    num_rolls_to_remove = length(rolls_to_remove)

    if num_rolls_to_remove == 0 do
      count
    else
      rolls_to_remove
      |> update_grid(grid)
      |> find_and_remove_rolls(count + num_rolls_to_remove)
    end
  end

  defp find_rolls_to_remove({_, 0}, _, acc), do: acc
  defp find_rolls_to_remove({coords, 1}, grid, acc) do
    if count_surrounding(coords, grid) < 4, do: [coords | acc], else: acc
  end

  defp count_surrounding({row, col}, grid) do
    [
      {-1, -1}, {-1, 0}, {-1, 1},
      {0, -1}, {0, 1},
      {1, -1}, {1, 0}, {1, 1}
    ]
    |> Enum.sum_by(fn {r, c} ->
      Map.get(grid, {row + r, col + c}, 0)
    end)
  end

  defp update_grid(rolls_to_remove, grid) do
    Enum.reduce(rolls_to_remove, grid, fn coords, g ->
      Map.put(g, coords, 0)
    end)
  end
end

IO.inspect(PrintingDepartment.run("input.txt"))
