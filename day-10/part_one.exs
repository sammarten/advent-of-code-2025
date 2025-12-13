defmodule Factory do
  def run(file) do
    file
    |> read_input()
    |> find_min_total_presses()
  end

  defp read_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&process_row/1)
  end

  defp find_min_total_presses(data) do
    data
    |> Enum.map(&find_min_presses/1)
    |> Enum.sum()
  end

  defp process_row(row) do
    [lights | elements] = String.split(row, " ", trim: true)
    {_joltage, wiring} = List.pop_at(elements, -1)

    %{
      lights: process_lights(lights),
      wiring: process_wiring(wiring)
    }
  end

  defp process_lights(lights) do
    lights
    |> String.replace("[", "")
    |> String.replace("]", "")
    |> String.replace(".", "0")
    |> String.replace("#", "1")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp process_wiring(wiring) do
    wiring
    |> Enum.map(&String.replace(&1, "(", ""))
    |> Enum.map(&String.replace(&1, ")", ""))
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
  end

  defp find_min_presses(data) do
    %{
      lights: lights,
      wiring: wiring
    } = data

    init_lights = Enum.map(1..length(lights), fn _ -> 0 end)

    Enum.reduce(subsets(wiring), nil, fn set, acc ->
      if press_buttons(set, init_lights) == lights && (is_nil(acc) || length(set) < acc) do
        length(set)
      else
        acc
      end
    end)
  end

  defp subsets([]), do: [[]]
  defp subsets([h | t]) do
    rest = subsets(t)
    rest ++ Enum.map(rest, &[h | &1])
  end

  defp press_buttons([], _), do: []

  defp press_buttons(buttons, lights) do
    buttons
    |> Enum.reduce(lights, fn wires, acc ->
      Enum.reduce(wires, acc, fn w, l ->
        List.update_at(l, w, &(&1 + 1))
      end)
    end)
    |> Enum.map(&rem(&1, 2))
  end
end

IO.inspect(Factory.run("input.txt"))
