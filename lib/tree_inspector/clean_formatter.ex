defmodule TreeInspector.CleanFormatter do

  def format(list),
    do: format(list, [])

  def format([], acc),
    do: acc

  def format([{:key, key} | tail], acc) when is_atom(key) do
    acc =
      acc ++ [to_string(key)]

    format(tail, acc)
  end

  def format([{:key, key} | tail], acc) do
    acc =
      acc ++ ["\"", to_string(key), "\""]

    format(tail, acc)
  end

  def format([:colon | tail], acc) do
    acc =
      acc ++ [" : "]

    format(tail, acc)
  end

  def format([:fat_arrow | tail], acc) do
    acc =
      acc ++ [" => "]

    format(tail, acc)
  end

  def format([{:type, type} | tail], acc) do
    acc =
      acc ++ [type]

    format(tail, acc)
  end

  def format([{:value, value} | tail], acc) when is_boolean(value) do
    acc =
      acc ++ [to_string(value)]

    format(tail, acc)
  end

  def format([{:value, value} | tail], acc) when is_nil(value) do
    acc =
      acc ++ ["nil"]

    format(tail, acc)
  end

  def format([{:value, value} | tail], acc) do
    acc =
      acc ++ [inspect(value)]

    format(tail, acc)
  end

  def format([value | tail], acc) when is_list(value) do
    acc =
      acc ++ format(value, [])

    format(tail, acc)
  end

  def format([value | tail], acc) do
    acc =
      acc ++ [value]

    format(tail, acc)
  end
end
