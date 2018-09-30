defmodule TreeInspector do
  alias TreeInspector.{
    Builder,
    Printer,
  }

  def inspect(thing, opts \\ []) do
    thing
    |> Builder.from(opts)
    |> Printer.print(opts)
  end
end
