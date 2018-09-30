defmodule TreeInspector.Builder do
  alias TreeInspector.Node

  @map_keys_blacklist [:__struct__]

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
    do: %Node{label: [{:key, key}, :colon, {:value, value}]}

  defp build_node(%Date{} = value, key, _opts),
    do: %Node{label: [{:key, key}, :colon, {:value, value}]}

  defp build_node(%Time{} = value, key, _opts),
    do: %Node{label: [{:key, key}, :colon, {:value, value}]}

  defp build_node(map, key, opts) when is_map(map) do
    skip_types = Keyword.get(opts, :skip_types, [])

    type =
      get_type(map)

    label =
      if key do
        [{:key, key}, :colon, type]
      else
        [type]
      end

    children =
      if Map.get(map, :__struct__) in skip_types do
        []
      else
        map
        |> get_map_keys(opts)
        |> Enum.map(fn k ->
          build_node(Map.get(map, k), k, opts)
        end)
      end

    %Node{
      label: label,
      children: children
    }
  end

  defp build_node(tuple, key, opts) when is_tuple(tuple) do
    list = Tuple.to_list(tuple)

    if length(list) > 2 do
      type = {:type, "{}"}

      label =
        if key do
          [{:key, key}, :colon, type]
        else
          [type]
        end

      %Node{
        label: label,
        children: build_node_list(list, opts)
      }
    else
      label =
        cond do
          is_nil(key) ->
            [{:value, tuple}]

          is_atom(key) ->
            [{:key, key}, :colon, {:value, tuple}]

          true ->
            [{:key, key}, :fat_arrow, {:value, tuple}]
        end

      %Node{label: label}
    end
  end

  defp build_node(list, key, opts) when is_list(list) do
    label =
      if key do
        [{:key, key}, :colon]
      else
        []
      end

    label = label ++ [{:type, "[]"}]

    %Node{
      label: label,
      children: build_node_list(list, opts)
    }
  end

  defp build_node(value, key, _opts) do
    label =
      cond do
        is_nil(key) ->
          [{:value, value}]

        is_atom(key) ->
          [{:key, key}, :colon, {:value, value}]

        true ->
          [{:key, key}, :fat_arrow, {:value, value}]
      end

    %Node{label: label}
  end

  defp get_type(%{__struct__: name}) do
    name
    |> to_string()
    |> String.slice(7..-1) # Remove "Elixir." prefix
    |> (&{:type, ["%", &1, "{}"]}).()
  end

  defp get_type(%{}),
    do: {:type, "%{}"}

  defp get_map_keys(map, opts) do
    skip_keys = Keyword.get(opts, :skip_keys, [])
    filter_fields = Keyword.get(opts, :filter_fields, fn _, _ -> true end)

    map
    |> Map.keys()
    |> Enum.filter(&(not (&1 in @map_keys_blacklist)))
    |> Enum.filter(&(not (&1 in skip_keys)))
    |> Enum.filter(fn k -> filter_fields.(k, Map.get(map, k)) end)
  end
end
