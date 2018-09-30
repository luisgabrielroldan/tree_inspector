defmodule TreeInspector.BuilderTest do
  use ExUnit.Case

  alias TreeInspector.{
    Builder,
    Printer,
    Node,
  }

  test "from/1" do
    Builder.from(
      %{
        text: "lorem",
        atom: :value,
        boolean: true,
        float: 0.003,
        naive_datetime: ~N[2018-09-17 23:24:44.257495],
        date: ~D[2018-09-17],
        time: ~T[23:24:44.257495],
        id: 100,
        obj: %Node{
          label: "A label",
          children: []
        },
        list: [
          [
            1,
            2.0,
            :three,
            "four",
            nil
          ],
          %Node{},
          %{
            "str1" => "a",
            "str2" => "b",
            "str3" => "c",
          }
        ]
      }
    )
    |> Printer.print()
  end
end
