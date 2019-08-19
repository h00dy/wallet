defmodule Wallet.Report do
  @moduledoc """
  Generates Report with expenses
  """
  alias Wallet.Parser
  alias Wallet.Report.Classifier

  def get_vendors(parser_data) do
    parser_data
    |> Enum.map(& &1.vendor)
    |> Enum.uniq()
  end

  defp load_file(file_name), do: Parser.parse(file_name)

  def add_to_report(report_data, file) do
    file
    |> load_file
    |> Enum.concat(report_data)
  end

  def build_report(file_list) when is_list(file_list)  do
    file_list
    |> Enum.reduce([], &add_to_report(&2, &1))
    |> group_by_month
    |> Task.async_stream(&summarize/1)
    |> Enum.to_list()
  end

  def summarize({key, vendors}) do
    summary =
      vendors
      |> Classifier.classify
      |> Enum.reduce(%{}, fn record, acc ->
        Map.update(acc, record.class, record.value, &(&1 + record.value))
      end)

    {key, summary}
  end

  def group_by_month(vendors) do
    vendors
    |> Enum.group_by(fn vendor ->
      {_y, month, _d} = Date.to_erl(vendor.date)
      month
    end)
  end

end
