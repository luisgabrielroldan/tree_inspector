defmodule TreeDraw do

  def inspect(nodes, opts \\ [])

  def inspect(nodes, opts) when is_list(nodes) do
    do_draw(nodes, "", true, opts)
  end

  def inspect(node, opts) when is_map(node) do
    do_draw([node], "", true, opts)
  end

  defp node_type_format(text) do
    IO.ANSI.red <> IO.ANSI.bright <> text <> IO.ANSI.reset
  end

  defp do_draw([], _, _, _),
    do: nil
  defp do_draw([node | tail], indent, root?, opts) do
    ch =
      if tail == [] do
        "└─"
      else
        "├─"
      end

    if root? do
      IO.puts "#{indent} ▶ #{node_type_format(node_type(node))}"
    else
      IO.puts "#{indent}#{ch} #{node_type_format(node_type(node))}"
    end

    next_indent =
      if tail == [] do
        indent <> "   "
      else
        indent <> "│  "
      end

    enum_keys =
      get_enumerable_keys(node, opts)

    object_keys =
      get_object_keys(node, opts)

    node
    |> get_value_keys(opts)
    |> do_draw_values(node, next_indent, length(enum_keys) + length(object_keys) == 0, opts)

    do_object_values(object_keys, node, next_indent, length(enum_keys) == 0, opts)

    do_draw_lists(enum_keys, node, next_indent, opts)

    do_draw(tail, indent, false, opts)
  end

  defp do_draw_values([], _, _, _, _), do: nil
  defp do_draw_values([key | tail], node, indent, is_last?, opts) do
    if tail == [] and is_last? do
      IO.puts "#{indent}└─ #{IO.ANSI.bright}#{to_string(key)}:#{IO.ANSI.reset} #{Kernel.inspect(Map.get(node, key))}"
    else
      IO.puts "#{indent}├─ #{IO.ANSI.bright}#{to_string(key)}:#{IO.ANSI.reset} #{Kernel.inspect(Map.get(node, key))}"
    end

    do_draw_values(tail, node, indent, is_last?, opts)
  end

  defp do_object_values([], _, _, _, _), do: nil
  defp do_object_values([key | tail], node, indent, is_last?, opts) do
    if tail == [] and is_last? do
      IO.puts "#{indent}└─ #{IO.ANSI.bright <> IO.ANSI.cyan}#{to_string(key)}#{IO.ANSI.reset}"
    else
      IO.puts "#{indent}├─ #{IO.ANSI.bright <> IO.ANSI.cyan}#{to_string(key)}#{IO.ANSI.reset}"
    end

    next_indent =
      if tail == [] and is_last? do
        indent <> "   "
      else
        indent <> "│  "
      end

    do_draw([Map.get(node, key)], next_indent, false, opts)

    do_object_values(tail, node, indent, is_last?, opts)
  end

  defp do_draw_lists([], _, _, _), do: nil
  defp do_draw_lists([key | tail], node, indent, opts) do
    if tail == [] do
      IO.puts "#{indent}└─ #{IO.ANSI.bright <> IO.ANSI.blue}[#{to_string(key)}]#{IO.ANSI.reset}"
    else
      IO.puts "#{indent}├─ #{IO.ANSI.bright <> IO.ANSI.blue}[#{to_string(key)}]#{IO.ANSI.reset}"
    end

    next_indent =
      if tail == [] do
        indent <> "   "
      else
        indent <> "│  "
      end

    do_draw(Map.get(node, key), next_indent, false, opts)

    do_draw_lists(tail, node, indent, opts)
  end

  defp get_value_keys(node, opts) do
    keys =
      node
      |> Map.keys()
      |> Enum.filter(&(!match?("__" <> _, to_string(&1))))
      |> Enum.filter(fn key ->
        !is_map(Map.get(node, key))
      end)
      |> Enum.filter(fn key ->
        !is_list(Map.get(node, key))
      end)

    if is_list(opts[:whitelist]) do
      Enum.filter(keys, &(&1 in opts[:whitelist]))
    else
      keys
    end
  end

  defp get_object_keys(node, opts) do
    keys =
      node
      |> Map.keys()
      |> Enum.filter(&(!match?("__" <> _, to_string(&1))))
      |> Enum.filter(fn key ->
        is_map(Map.get(node, key))
      end)

    if is_list(opts[:whitelist]) do
      Enum.filter(keys, &(&1 in opts[:whitelist]))
    else
      keys
    end
  end

  defp get_enumerable_keys(node, opts) do
    keys =
      node
      |> Map.keys()
      |> Enum.filter(&(!match?("__" <> _, to_string(&1))))
      |> Enum.filter(fn key ->
        is_list(Map.get(node, key))
      end)

    if is_list(opts[:whitelist]) do
      Enum.filter(keys, &(&1 in opts[:whitelist]))
    else
      keys
    end
  end

  defp node_type(%{__struct__: name}),
    do: "(" <> String.slice(to_string(name), 7..-1) <> ")"

  defp node_type(_),
    do: "(Map)"
end
