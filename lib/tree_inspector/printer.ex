defmodule TreeInspector.Printer do
  alias TreeInspector.Node

  @child_stroke "├─"
  @child_stroke_last "└─"

  def print(nodes) when is_list(nodes) do
    nodes
    |> print_nodes("", true, [])
    |> IO.puts()
  end

  def print(%Node{} = node),
    do: print([node])

  defp print_nodes([], _, _, output),
    do: output

  defp print_nodes([%Node{} = node | tail], indent, root?, output) do
    last_child? = tail == []

    stroke =
      if last_child? do
        @child_stroke_last
      else
        @child_stroke
      end

    pre =
      if root? do
        ""
      else
        "#{indent}#{stroke} "
      end

    output = output ++ [pre, node_label(node), "\n"]

    next_indent =
      cond do
        root? -> " "
        last_child? -> indent <> "   "
        true -> indent <> "│  "
      end

    output = print_nodes(node.children, next_indent, false, output)

    print_nodes(tail, indent, root?, output)
  end

  defp node_label(%Node{label: label}) when is_binary(label),
    do: label
  defp node_label(_),
    do: ""
end
