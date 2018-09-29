defmodule TreeInspector.PrinterTest do
  use ExUnit.Case

  alias TreeInspector.{
    Printer,
    Node,
  }

  @tree %Node{
    label: "Type",
    children: [
      %Node{
        label: "obj_1",
        children: [
          %Node{
            label: "foo",
            children: []
          },
          %Node{
            label: "bar",
            children: []
          }
        ]
      }
    ]
  }

  test "print/1" do
    Printer.print([@tree, @tree])
  end
end
