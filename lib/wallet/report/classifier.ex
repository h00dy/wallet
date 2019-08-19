defmodule Wallet.Report.Classifier do
  alias Wallet.Report.Classifier

  @type t :: %Classifier{name: String.t(), filters: [String.t()]}

  defstruct name: "", filters: []

  def get_categories do
    # todo zmienićń na strukturę, ktora będize trzymać vendorow
    [
      %Classifier{name: "Wynagrodzenie", filters: ["ALLEGRO.PL SP. Z O.O."]},
      %Classifier{name: "Karta kredytowa", filters: ["spłata", "84103000228908069687085726"]},
      %Classifier{name: "Zasilenie konta", filters: ["16103000190109852500041756"]},
      %Classifier{name: "Zdrowie", filters: ~w[apteka synevo lekarz przychodnia nukleomed chillident]},
      %Classifier{name: "Zakupy", filters: ~w[TESCO rossman piotr chata netto supermarket yves empik fotojoker zabka MAMERT HERBATE Mieso Allegro ligawa freshmarket]},
      %Classifier{name: "Rozrywka", filters: ~w[Spotify netflix kwiaciarnia booking]},
      %Classifier{name: "Samochod", filters: ~w[berdychowski circle ppo spo]},
      %Classifier{name: "Dla domu", filters: ~w[ogrod]},
      %Classifier{name: "Rachunki", filters: ["inea", "enea", "pgnig", "peka", "goap", "orange", "za uslugi I", "36103000190109853000298138", "skarbowy", "Trust"]},
      %Classifier{name: "Restauracje", filters: ~w[Restauracja pizzeria tusieje burger Paczkarnia burgs pyszne gastronomia cafe caffe cukiernia smazalnia kolorowa]},
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

  def classify(vendors) do
    vendors
    |> assign_to_class(get_categories())
  end

  defp assign_to_class(vendors, categories) do
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
