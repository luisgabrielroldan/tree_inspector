defmodule TreeInspector.Formatter do
  alias IO.ANSI

  def format_arrow(arrow),
    do: "#{ANSI.red()}#{arrow}#{ANSI.reset()}"

  def format_type_name(text),
    do: "#{ANSI.bright()}#{ANSI.blue()}#{text}#{ANSI.reset()}"

  def format_key(key) when is_atom(key),
    do: "#{ANSI.bright()}#{to_string(key)}#{ANSI.reset()}"

  def format_key(key),
    do: "#{ANSI.green()}\"#{key}\"#{ANSI.reset()}"

  def format_value(true),
    do: "#{ANSI.magenta()}true#{ANSI.reset()}"

  def format_value(false),
    do: "#{ANSI.magenta()}false#{ANSI.reset()}"

  def format_value(value) when is_nil(value),
    do: "#{ANSI.magenta()}nil#{ANSI.reset()}"

  def format_value(value) when is_binary(value),
    do: "#{ANSI.green()}#{Kernel.inspect(value)}#{ANSI.reset()}"

  def format_value(value) when is_integer(value) or is_float(value),
    do: "#{ANSI.yellow()}#{Kernel.inspect(value)}#{ANSI.reset()}"

  def format_value(value) when is_atom(value),
    do: "#{ANSI.cyan()}#{Kernel.inspect(value)}#{ANSI.reset()}"

    def format_value(value),
    do: "#{ANSI.yellow()}#{Kernel.inspect(value)}#{ANSI.reset()}"
end
