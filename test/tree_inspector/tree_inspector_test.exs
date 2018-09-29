defmodule TreeInspectorTest.Node do
  defstruct name: nil, items: nil, other: nil
end

defmodule TreeInspectorTest do
  use ExUnit.Case

  alias TreeInspectorTest.Node

  @tree %Node{
    name: "foo",
    items: [
      %{
        name: "bar",
        items: [
          %Node{
            name: "baz",
            items: []
          }
        ]
      },
      %Node{
        name: "100",
    items: [
      %Node{
        name: "bar",
        items: [
          %Node{
            name: "baz",
            items: []
          }
        ]
      },
      %Node{
        name: "100",
        items: []
      },
      %Node{
        name: "100",
        items: []
      }
    ]
      },
      %Node{
        name: "100",
        items: []
      }
    ]
  }

  test "show me the money" do
    TreeInspector.inspect(@tree)
  end
end
