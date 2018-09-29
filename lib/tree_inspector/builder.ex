defmodule TreeInspector.Builder do
  alias TreeInspector.Node

  @map_keys_blacklist [:__struct__]
  @default_formatter TreeInspector.Formatter

  def from(element, opts \\ [])

  def from(elements_list, opts) when is_list(elements_list),
    do: build_node(elements_list, nil, opts)

  def from(element, opts),
    do: build_node(element, nil, opts)

  defp build_node_list([], _opts),
    do: []

  defp build_node_list([element | tail], opts),
    do: [build_node(element, nil, opts)] ++ build_node_list(tail, opts)

  # For the well known structures we can to represent them
  # with the default inspect result string
  defp build_node(%NaiveDateTime{} = value, key, _opts),
    do: %Node{label: "#{format_key(key)} : #{format_value(value)}"}

  defp build_node(%Date{} = value, key, _opts),
    do: %Node{label: "#{format_key(key)} : #{format_value(value)}"}

  defp build_node(%Time{} = value, key, _opts),
    do: %Node{label: "#{format_key(key)} : #{format_value(value)}"}

  defp build_node(map, key, opts) when is_map(map) do
    type =
      map
      |> get_struct_name()
      |> format_type_name()

    label =
      if key do
        "#{format_key(key)} : #{type}"
      else
        type
      end

    children =
      map
      |> get_map_keys(opts)
      |> Enum.map(fn k ->
        build_node(Map.get(map, k), k, opts)
      end)

    %Node{
      label: label,
      children: children
    }
  end

  defp build_node(list, key, opts) when is_list(list) do
    type = format_type_name("[]")

    label =
      if key do
        "#{format_key(key)} : #{type}"
      else
        type
      end

    %Node{
      label: label,
      children: build_node_list(list, opts)
    }
  end

  defp build_node(value, key, _opts) do
    label =
      cond do
        is_nil(key) ->
          format_value(value)

        is_atom(key) ->
          "#{format_key(key)} : #{format_value(value)}"

        true ->
          arrow = format_arrow("=>")
          "#{format_key(key)} #{arrow} #{format_value(value)}"
      end

    %Node{label: label}
  end

  defp get_struct_name(%{__struct__: name}) do
    name
    |> to_string()
    |> String.slice(7..-1) # Remove "Elixir." prefix
    |> (&"%#{&1}{}").()
  end

  defp get_struct_name(%{}),
    do: "%{}"

  defp format_arrow(arrow),
    do: @default_formatter.format_arrow(arrow)

  defp format_type_name(name),
    do: @default_formatter.format_type_name(name)

  defp format_key(key),
    do: @default_formatter.format_key(key)

  defp format_value(value),
    do: @default_formatter.format_value(value)

  defp get_map_keys(map, _opts) do
    map
    |> Map.keys()
    |> Enum.filter(&(not (&1 in @map_keys_blacklist)))
  end
end
