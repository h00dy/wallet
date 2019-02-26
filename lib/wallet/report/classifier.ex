defmodule Wallet.Report.Classifier do
  alias Wallet.Report.Classifier

  @type t :: %Classifier{name: String.t(), filters: [String.t()]}

  defstruct name: "", filters: []

  def get_categories do
    # todo zmienićń na strukturę, ktora będize trzymać vendorow
    [
      %Classifier{name: "Zdrowie", filters: ~w[apteka synevo lekarz przychodnia nukleomed]},
      %Classifier{name: "Zakupy", filters: ~w[TESCO rossman piotr chata netto supermarket yves empik fotojoker zabka MAMERT HERBATE Mieso Allegro]},
      %Classifier{name: "Rozrywka", filters: ~w[Spotify netflix]},
      %Classifier{name: "Samochod", filters: ~w[berdychowski circle ppo spo]},
      %Classifier{name: "Rachunki", filters: ["inea", "enea", "pgnig", "peka", "goap", "orange", "za uslugi I", "36103000190109853000298138"]},
      %Classifier{name: "Restauracje", filters: ~w[Restauracja pizzeria tusieje burger Paczkarnia burgs]},
      %Classifier{name: "Kredyt", filters: ["pocztowym"]},
      %Classifier{name: "Konto oszczędnościowe", filters: ["16103000190109852500041756"]},
      %Classifier{name: "Ubezpieczenie", filters: ["ubezpieczenie", "NATIONALE-NEDERLANDEN"]},
      %Classifier{name: "Inne", filters: [" "]}
    ]
  end

  def category_names do
    get_categories()
    |> Enum.map(& &1.name)
  end

  def assign_to_class(vendors, categories) do
    vendors
    |> Enum.map(&assign(&1, categories))
  end

  defp assign(vendor, categories) do
    find_category = fn category, vendor ->
      category.filters
      |> Enum.map(&String.downcase(&1))
      |> Enum.any?(&String.contains?(String.downcase(vendor), &1))
    end

    categories
    |> Enum.reduce_while(
      %Classifier.Vendor{name: vendor.vendor, value: vendor.value, class: "Inne"},
      fn category, acc ->
        if find_category.(category, vendor.vendor) do
          {:halt,
           %Classifier.Vendor{name: vendor.vendor, value: vendor.value, class: category.name}}
        else
          {:cont, acc}
        end
      end
    )
  end
end
