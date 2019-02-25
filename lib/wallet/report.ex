defmodule Wallet.Report do
  @moduledoc """
  Generates Report with expenses
  """
  alias Wallet.Parser
  alias Wallet.Report.Classifier

  # 1. chunk by months
  # 2. merge by vendor
  # OR
  # 1. get vendors
  # 2. assign vendors to classes

  def get_vendors(parser_data) do
    parser_data
    |> Enum.map(& &1.vendor)
    |> Enum.uniq()
  end

  def load_file(file_name), do: Parser.parse(file_name)

  def build_report do
    load_file("ACCT_11_02_2019.csv")
    |> Enum.group_by(fn vendor ->
      {_y, month, _d} = Date.to_erl(vendor.date)
      month
    end)
    |> Task.async_stream(&summarize/1)
    |> Enum.to_list()
  end

  def summarize({key, vendors}) do
    summary =
      vendors
      |> Classifier.assign_to_class(Classifier.get_categories())
      |> Enum.reduce(%{}, fn record, acc ->
        IO.inspect({self(), record, acc})
        Map.update(acc, record.class, record.value, &(&1 + record.value))
      end)

    {key, summary}
  end
end
