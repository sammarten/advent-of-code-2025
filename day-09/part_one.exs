defmodule MovieTheater do
  def run(file) do
    file
    |> read_input()
    |> find_largest_rect()
  end

  defp read_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&to_integers/1)
  end

  defp to_integers(values) do
    Enum.map(values, &String.to_integer/1)
  end

  defp find_largest_rect(squares) do
    squares_to_iterate = List.delete_at(squares, -1)
    squares_to_compare = List.delete_at(squares, 0)

    init_acc = %{
      largest_rect: 0,
      comp: squares_to_compare
    }

    Enum.reduce(squares_to_iterate, init_acc, &find_largest_rect/2)
    |> Map.get(:largest_rect)
  end

  defp find_largest_rect([s1, s2], acc) do
    updated_largest_rect =
      Enum.reduce(acc.comp, acc.largest_rect, fn [t1, t2], lr ->
        size = ((abs(s1 - t1) + 1) * (abs(s2 - t2) + 1))

        if size > lr, do: size, else: lr
    end)

    %{largest_rect: updated_largest_rect, comp: List.delete_at(acc.comp, 0)}
  end
end

IO.inspect(MovieTheater.run("input.txt"))
