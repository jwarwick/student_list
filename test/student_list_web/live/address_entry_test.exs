defmodule StudentListWeb.AddressEntryTest do
  use StudentListWeb.ConnCase
  use Surface.LiveViewTest

  alias StudentListWeb.Live.AddressEntry

  @endpoint Endpoint

  test "render an address entry component" do
    html = render_surface do
      ~F"""
      <AddressEntry
        id={"address-1"}
        address={%{"adults" => [%{}]}}
        index={0}
        can_delete={false} />
      """
    end

    assert html =~ "Household"
    assert html =~ "Add Another Adult"
    assert html =~ "Address 1"
    assert html =~ "Address 2"
    assert html =~ "City"
    assert html =~ "State"
    assert html =~ "Zip"
    assert html =~ "Home Phone"
    refute html =~ "Remove Household"
    refute html =~ "phx-click=\"delete_address\""
  end

  test "render a deletable address entry component" do
    html = render_surface do
      ~F"""
      <AddressEntry
        id={"address-1"}
        address={%{"adults" => [%{}]}}
        index={0}
        can_delete={true} />
      """
    end

    assert html =~ "Household"
    assert html =~ "Add Another Adult"
    assert html =~ "Address 1"
    assert html =~ "Address 2"
    assert html =~ "City"
    assert html =~ "State"
    assert html =~ "Zip"
    assert html =~ "Home Phone"
    assert html =~ "Remove Household"
    assert html =~ "phx-click=\"delete_address\""
  end
end
