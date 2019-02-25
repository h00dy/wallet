defmodule Wallet.Parser do
  @moduledoc """
  Module for importing and parsing csv files
  """
  require Logger
  alias Wallet.Parsers.Csv
  @callback parse(String.t()) :: list(Wallet.Parser.Output.t())

  def parse(file_name, parser_module \\ Csv) when is_binary(file_name) do
    parser_module.parse(file_name)
  end
end

defmodule Wallet.Parser.Output do
  @type t :: %Wallet.Parser.Output{
          vendor: String.t(),
          value: float,
          date: Date.t()
        }
  defstruct vendor: "", value: 0, date: nil
end
