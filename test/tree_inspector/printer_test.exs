defmodule TreeInspector.PrinterTest do
  use ExUnit.Case

  alias TreeInspector.{
    Printer,
    Node
  }

  test "print binary labels" do
    lines =
      %Node{
        label: "L1",
        children: [
          %Node{
            label: "L2",
            children: []
          }
        ]
      }
      |> Printer.print(output: :return)
      |> to_lines()

    assert lines == [
             " L1",
             " └─ L2"
           ]
  end

  test "print iolist labels" do
    lines =
      %Node{
        label: ["L", "1"],
        children: [
          %Node{
            label: ["L2"],
            children: []
          }
        ]
      }
      |> Printer.print(output: :return)
      |> to_lines()

    assert lines == [
             " L1",
             " └─ L2"
           ]
  end

  defp to_lines(tree) do
    tree
    |> String.split("\n")
    |> Enum.filter(&(&1 !== ""))
  end
end
