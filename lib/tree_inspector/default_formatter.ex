defmodule TreeInspector.DefaultFormatter do
  alias IO.ANSI

  @default_color_schema [
    fat_arrow: 9,
    type: 12,
    key_atom: nil,
    key_binary: 10,
    value_boolean: 9,
    value_nil: 9,
    value_binary: 10,
    value_number: 11,
    value_atom: 14,
    value_other: 11
  ]

  defp colorize(color_key, text) do
    case @default_color_schema[color_key] do
      nil -> [text, ANSI.reset()]
      color -> [ANSI.color(color), text, ANSI.reset()]
    end
  end

  defp b,
    do: ANSI.bright()

  def format(list),
    do: format(list, [])

  def format([], acc),
    do: acc

  def format([{:key, key} | tail], acc) when is_atom(key) do
    acc =
      acc ++ colorize(:key_atom, [b(), to_string(key)])

    format(tail, acc)
  end

  def format([{:key, key} | tail], acc) do
    acc =
      acc ++ colorize(:key_binary, [b(), "\"", to_string(key), "\""])

    format(tail, acc)
  end

  def format([:colon | tail], acc) do
    acc =
      acc ++ [" : "]

    format(tail, acc)
  end

  def format([:fat_arrow | tail], acc) do
    acc =
      acc ++ colorize(:fat_arrow, [" => "])

    format(tail, acc)
  end

  def format([{:type, type} | tail], acc) do
    acc =
      acc ++ colorize(:type, [b(), type])

    format(tail, acc)
  end

  def format([{:value, value} | tail], acc) when is_boolean(value) do
    acc =
      acc ++ colorize(:value_boolean, [to_string(value)])

    format(tail, acc)
  end

  def format([{:value, value} | tail], acc) when is_nil(value) do
    acc =
      acc ++ colorize(:value_nil, ["nil"])

    format(tail, acc)
  end

  def format([{:value, value} | tail], acc) do
    color_key =
      cond do
        is_binary(value) -> :value_binary
        is_integer(value) or is_float(value) -> :value_number
        is_atom(value) -> :value_atom
        true -> :value_other
      end

    acc =
      acc ++ colorize(color_key, [inspect(value)])

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
