defmodule Wallet.Report.Classifier.Vendor do
  alias Wallet.Report.Classifier.Vendor

  @type t :: %Vendor{name: String.t, value: float, class: String.t}

  defstruct name: "", value: 0, class: ""
end
