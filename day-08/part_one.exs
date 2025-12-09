defmodule Playground do
  @connection_limit 1000

  def run(file) do
    file
    |> read_input()
    |> calc_distances()
    |> create_circuits()
    |> multiply_largest_circuits()
  end

  def read_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn d -> Enum.map(d, &String.to_integer/1) |> List.to_tuple() end)
  end

  defp calc_distances(boxes) do
    boxes_to_iterate = List.delete_at(boxes, -1)
    boxes_to_compare = List.delete_at(boxes, 0)

    boxes_to_iterate
    |> Enum.reduce(%{boxes_to_compare: boxes_to_compare, distances: []}, &calc_distances/2)
    |> Map.get(:distances)
    |> Enum.sort_by(fn {distance, _} -> distance end)
  end

  defp calc_distances(box, acc) do
    new_distances =
      Enum.map(acc.boxes_to_compare, &calc_distance(&1, box))

    %{boxes_to_compare: List.delete_at(acc.boxes_to_compare, 0), distances: acc.distances ++ new_distances}
  end

  defp calc_distance({x1, y1, z1} = a, {x2, y2, z2} = b) do
    distance =
      :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2))

    {distance, [a, b]}
  end

  defp create_circuits(distances) do
    acc = %{
      num_connections: 0,
      circuits: %{}, # int => MapSet
      circuit_lookup: %{}
    }

    Enum.reduce_while(distances, acc, &process_circuit/2)
    |> Map.get(:circuits)
  end

  defp process_circuit({_, [a, b]}, acc) do
    %{circuit_lookup: circuit_lookup} = acc

    # see if a or b are already in circuits
    # if both are and circuit is the same, do nothing
    # if neither are, link them
    # if one is, add the other to the circuit
    # if both are and circuits are different, join circuits
    case {circuit_lookup[a], circuit_lookup[b]} do
      {nil, nil} -> create_circuit(a, b, acc)
      {c, nil} -> add_box_to_circuit(c, b, acc)
      {nil, c} -> add_box_to_circuit(c, a, acc)
      {c, c} -> {:cont, %{acc | num_connections: acc.num_connections + 1}}
      {c1, c2} -> merge_circuits(c1, c2, acc)
    end
  end

  defp create_circuit(a, b, acc) do
    %{
      num_connections: num_connections,
      circuits: circuits,
      circuit_lookup: circuit_lookup
    } = acc

    circuit_id =
      if Enum.count(circuits) > 0 do
        circuits
        |> Enum.map(fn {i, _} -> i end)
        |> Enum.max()
        |> Kernel.+(1)
      else
        0
      end

    updated_circuits = Map.put(circuits, circuit_id, MapSet.new([a, b]))

    updated_circuit_lookup =
      circuit_lookup
      |> Map.put(a, circuit_id)
      |> Map.put(b, circuit_id)

    updated_num_connections = num_connections + 1

    updated_acc = %{
      num_connections: updated_num_connections,
      circuits: updated_circuits,
      circuit_lookup: updated_circuit_lookup
    }

    if updated_num_connections == @connection_limit do
      {:halt, updated_acc}
    else
      {:cont, updated_acc}
    end
  end

  defp add_box_to_circuit(circuit_id, box, acc) do
    %{
      num_connections: num_connections,
      circuits: circuits,
      circuit_lookup: circuit_lookup
    } = acc

    circuit_boxes = Map.get(circuits, circuit_id)
    updated_circuit_boxes = MapSet.put(circuit_boxes, box)
    updated_circuits = Map.put(circuits, circuit_id, updated_circuit_boxes)

    updated_circuit_lookup =
      Map.put(circuit_lookup, box, circuit_id)

    updated_num_connections = num_connections + 1

    updated_acc = %{
      num_connections: updated_num_connections,
      circuits: updated_circuits,
      circuit_lookup: updated_circuit_lookup
    }

    if updated_num_connections == @connection_limit do
      {:halt, updated_acc}
    else
      {:cont, updated_acc}
    end
  end

  defp merge_circuits(cid1, cid2, acc) do
    %{
      num_connections: num_connections,
      circuits: circuits,
      circuit_lookup: circuit_lookup
    } = acc

    b1 = Map.get(circuits, cid1)
    b2 = Map.get(circuits, cid2)

    updated_circuit_boxes = MapSet.union(b1, b2)

    updated_circuits =
      circuits
      |> Map.put(cid1, updated_circuit_boxes)
      |> Map.delete(cid2)

    updated_circuit_lookup =
      Enum.reduce(MapSet.to_list(b2), circuit_lookup, fn b, acc ->
        Map.put(acc, b, cid1)
      end)

    updated_num_connections = num_connections + 1

    updated_acc = %{
      num_connections: updated_num_connections,
      circuits: updated_circuits,
      circuit_lookup: updated_circuit_lookup
    }

    if updated_num_connections == @connection_limit do
      {:halt, updated_acc}
    else
      {:cont, updated_acc}
    end
  end

  defp multiply_largest_circuits(circuits) do
    circuits
    |> Enum.map(fn {_, boxes} -> MapSet.size(boxes) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end
end

IO.inspect(Playground.run("input.txt"))
