defmodule Wallet.ReportTest do
  use ExUnit.Case

  @input_file "test/wallet/test_input.csv"

  test "build report from single file" do
    [ok: {key, summary}] = Wallet.Report.build_report([@input_file])
    assert({2, %{"Zakupy" => -60.94, "Zdrowie" => -189.2}} == {key, summary})
  end

  test "build report from list of files" do
    [ok: {key, summary}] = Wallet.Report.build_report([@input_file, @input_file])
    assert({2, %{"Zakupy" => -121.88, "Zdrowie" => -378.4}} == {key, summary})
  end
end
