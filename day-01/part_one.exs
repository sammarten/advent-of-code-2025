defmodule SecretEntrance do
  def run(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Stream.map(&to_clicks/1)
    |> Enum.reduce(%{position: 50, password: 0}, &process_clicks/2)
    |> Map.get(:password)
    |> dbg()
  end

  defp to_clicks("L" <> clicks), do: {:left, String.to_integer(clicks)} |> IO.inspect()
  defp to_clicks("R" <> clicks), do: {:right, String.to_integer(clicks)} |> IO.inspect()

  defp process_clicks({direction, clicks}, acc) do
    updated_position =
      case direction do
        :left -> go_left(acc.position, clicks)
        :right -> go_right(acc.position, clicks)
      end

    if updated_position == 0 do
      %{acc | position: 0, password: acc.password + 1}
    else
      %{acc | position: updated_position}
    end
    |> IO.inspect()
  end

  defp go_left(position, clicks), do: to_position(position - clicks)

  defp go_right(position, clicks), do: to_position(position + clicks)

  defp to_position(position) do
    rotated_position = rem(position, 100)

    cond do
      rotated_position < 0 ->
        100 + rotated_position

      true ->
        rotated_position
    end
  end
end

IO.inspect(SecretEntrance.run("input.txt"))
