defmodule TrashCompactor do
  def run(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reduce(0, &process_problems/2)
  end

  defp process_problems(problem, acc) do
    [operand | digits] = Enum.reverse(problem)
    [d | rem_digits] = Enum.map(digits, &String.to_integer/1)

    value =
      Enum.reduce(rem_digits, d, fn a, b ->
        case operand do
          "+" -> a + b
          "*" -> a * b
        end
    end)

    acc + value
  end
end

IO.inspect(TrashCompactor.run("input.txt"))
