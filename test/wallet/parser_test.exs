defmodule Wallet.Parsers.CsvTest do
  use ExUnit.Case

  @parser_output [
    %Wallet.Parser.Output{
      date: ~D[2019-02-06],
      value: -53.14,
      vendor: "CZAS NA HERBATE          POZNAN       PL"
    },
    %Wallet.Parser.Output{
      date: ~D[2019-02-06],
      value: -189.2,
      vendor: "APTEKA PHARMACON         POZNAN       PL"
    },
    %Wallet.Parser.Output{
      date: ~D[2019-02-02],
      value: -7.8,
      vendor: "F.H.U. MAMERT s.c.       POZNAN       PL"
    }
  ]

  test "parsing csv file" do
    assert Wallet.Parser.parse("test/wallet/test_input.csv") == @parser_output
  end
end
