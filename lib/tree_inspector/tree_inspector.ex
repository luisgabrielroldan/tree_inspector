defmodule TreeInspector do
  alias TreeInspector.{
    Builder,
    Printer,
  }

  def inspect(thing) do
    thing
    |> Builder.from()
    |> Printer.print()
  end
end
