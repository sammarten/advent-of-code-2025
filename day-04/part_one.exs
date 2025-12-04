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
    Enum.reduce(grid, 0, fn
      {_, 0}, acc ->
        acc

      {coords, 1}, acc ->
        if count_surrounding(coords, grid) < 4, do: acc + 1, else: acc
    end)
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

end

IO.inspect(PrintingDepartment.run("input.txt"))
