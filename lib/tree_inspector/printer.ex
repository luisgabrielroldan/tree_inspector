defmodule TreeInspector.Printer do

  alias TreeInspector.{
    CleanFormatter,
    DefaultFormatter,
    Node,
  }

  @default_opts [
    formatter: :default,
    output: :stdio
  ]

  @child_stroke "├─"
  @child_stroke_last "└─"
  @prev_stroke "│"

  def print(nodes, opts \\ [])

  def print(nodes, opts) when is_list(nodes) do
    opts =
      Keyword.merge(@default_opts, opts)

    iolist =
      print_nodes(nodes, [], true, [])

    iolist =
      if opts[:formatter] == :clean do
        CleanFormatter.format(iolist)
      else
        DefaultFormatter.format(iolist)
      end

    if opts[:output] == :return do
      to_string(iolist)
    else
      IO.puts(opts[:output], iolist)
    end
  end

  def print(%Node{} = node, opts),
    do: print([node], opts)

  defp print_nodes([], _, _, acc),
    do: acc

  defp print_nodes([%Node{} = node | tail], indent, root?, acc) do
    last_child? = tail == []

    stroke =
      if last_child? do
        @child_stroke_last
      else
        @child_stroke
      end

    left =
      if root? do
        []
      else
        [indent, stroke]
      end

    acc = acc ++ [left, " ", node_label(node), "\n"]

    next_indent =
      cond do
        root? -> [" "]
        last_child? -> [indent, "   "]
        true -> [indent, @prev_stroke, "  "]
      end

    acc = print_nodes(node.children, next_indent, false, acc)

    print_nodes(tail, indent, root?, acc)
  end

  defp node_label(%Node{label: label}) when is_list(label),
    do: label
  defp node_label(%Node{label: label}) when is_binary(label),
    do: label
  defp node_label(_),
    do: []
end
