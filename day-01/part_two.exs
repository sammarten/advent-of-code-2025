defmodule SecretEntrance do
  def run(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Stream.map(&to_clicks/1)
    |> Enum.reduce(%{position: 50, password: 0}, &process_clicks/2)
    |> Map.get(:password)
    # |> dbg()
  end

  defp to_clicks("L" <> clicks), do: {:left, String.to_integer(clicks)}
  defp to_clicks("R" <> clicks), do: {:right, String.to_integer(clicks)}

  defp process_clicks({direction, clicks}, acc) do
    {updated_position, clicks_on_zero} =
      case direction do
        :left -> go_left(acc.position, clicks)
        :right -> go_right(acc.position, clicks)
      end

      %{position: updated_position, password: acc.password + clicks_on_zero}
  end

  defp go_left(position, clicks), do: to_position(position, position - clicks)

  defp go_right(position, clicks), do: to_position(position, position + clicks)

  defp to_position(starting_position, ending_position) do
    clicks_on_zero =
      cond do
        never_crossed_zero?(ending_position) -> 0
        ended_on_zero?(ending_position) -> 1
        crossed_below_zero?(ending_position) -> calc_crossed_below_zero(starting_position, ending_position)
        crossed_above_one_hundred?(ending_position) -> calc_crossed_above_one_hundred(ending_position)
      end

    dial_position =
      case rem(ending_position, 100) do
        value when value < 0 -> 100 + value
        value -> value
      end

    {dial_position, clicks_on_zero}
  end

  defp never_crossed_zero?(ending_position) do
    ending_position > 0 && ending_position <= 99
  end

  defp ended_on_zero?(ending_position) do
    ending_position == 0
  end

  defp crossed_below_zero?(ending_position) do
    ending_position < 0
  end

  defp calc_crossed_below_zero(0, ending_position) do
    abs(div(ending_position, 100))
  end

  defp calc_crossed_below_zero(_, ending_position) do
    abs(div(ending_position, 100)) + 1
  end

  defp crossed_above_one_hundred?(ending_position) do
    ending_position > 99
  end

  defp calc_crossed_above_one_hundred(ending_position) do
    div(ending_position, 100)
  end
end

IO.inspect(SecretEntrance.run("input.txt"))
