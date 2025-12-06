defmodule TrashCompactor do
  def run(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.chunk_while([], &process_chunk/2, &process_after/1)
    |> Enum.reduce(0, &process_problems/2)
  end

  defp process_chunk(row, acc) do
      if Enum.all?(row, fn e -> e == " " end) do
        {:cont, acc, []}
      else
        {:cont, [row | acc]}
      end
  end

  defp process_after(acc) do
    {:cont, acc, []}
  end

  defp process_problems(problem, acc) do
    [number_and_operand | rem_numbers] = Enum.reverse(problem)
    {number, [operand]} = Enum.split(number_and_operand, -1)

    [first_int | rem_ints] =
      [number | rem_numbers]
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    value =
      Enum.reduce(rem_ints, first_int, fn a, b ->
        case operand do
          "+" -> a + b
          "*" -> a * b
        end
    end)

    acc + value
  end
end

IO.inspect(TrashCompactor.run("input.txt"))
