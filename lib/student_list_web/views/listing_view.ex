defmodule StudentListWeb.ListingView do
  use StudentListWeb, :view

  def not_empty(nil), do: false
  def not_empty(str) do
    length = str |> String.trim |> String.length
    0 != length
  end
end
