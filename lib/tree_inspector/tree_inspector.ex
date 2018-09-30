defmodule TreeInspector do
  alias TreeInspector.{
    Builder,
    Printer
  }

  def inspect(thing, opts \\ []) 

  def inspect_fun(thing, %Inspect.Opts{custom_options: opts}),
    do: TreeInspector.inspect(thing, [{:output, :return} | opts])

  def inspect(thing, opts) when is_list(opts) do
    thing
    |> Builder.from(opts)
    |> Printer.print(opts)
  end

end
