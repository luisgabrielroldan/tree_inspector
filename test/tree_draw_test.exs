defmodule TreeDrawTest.Node do
  defstruct name: nil, items: nil, other: nil
end

defmodule TreeDrawTest do
  use ExUnit.Case

  @tree %TreeDrawTest.Node{
    name: "foo",
    items: [
      %{
        name: "bar",
        items: [
          %TreeDrawTest.Node{
            name: "baz",
            items: []
          }
        ]
      },
      %TreeDrawTest.Node{
        name: "100",
    items: [
      %TreeDrawTest.Node{
        name: "bar",
        items: [
          %TreeDrawTest.Node{
            name: "baz",
            items: []
          }
        ]
      },
      %TreeDrawTest.Node{
        name: "100",
        items: []
      },
      %TreeDrawTest.Node{
        name: "100",
        items: []
      }
    ]
      },
      %TreeDrawTest.Node{
        name: "100",
        items: []
      }
    ]
  }

  test "show me the money" do
    TreeDraw.inspect(@tree, whitelist: [:items, :name])
  end
end
