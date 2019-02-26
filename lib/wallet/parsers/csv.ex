defmodule Wallet.Parsers.Csv do
  @moduledoc """
  Module for importing and parsing csv files
  """
  alias NimbleCSV.RFC4180, as: CSV

  @behaviour Wallet.Parser

  def parse(file_path) do
    drop_head = fn [_ | tail] -> tail end

    file_path
    |> File.read!()
    |> to_charlist
    |> drop_head.()
    |> to_string
    |> CSV.parse_string(headers: false)
    |> Enum.map(fn [date_str, vendor, value | _] ->
      float_value = value
      |> String.replace(".", "")
      |> String.to_float
      %Wallet.Parser.Output{
        date: make_date(date_str),
        vendor: vendor,
        value: float_value
      }
    end)
  end

  defp make_date(date_str), do: Timex.parse!(date_str, "{D}/{M}/{YYYY}") |> Timex.to_date()
end
