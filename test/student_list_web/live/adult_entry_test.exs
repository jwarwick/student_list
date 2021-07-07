defmodule StudentListWeb.AdultEntryTest do
  use StudentListWeb.ConnCase
  use Surface.LiveViewTest

  alias StudentListWeb.Live.AdultEntry

  @endpoint Endpoint


  test "render an adult entry component" do
    html = render_surface do
      ~F"""
      <AdultEntry
        id={"adult-0-0"}
        adult={%{}}
        index={0}
        address_index={0}
        can_delete={false} />
      """
    end

    assert html =~ "Adult"
    assert html =~ "First Name"
    assert html =~ "Last Name"
    assert html =~ "Email"
    assert html =~ "Mobile Phone"
    refute html =~ "Remove Adult"
    refute html =~ "phx-click=\"delete_adult\""
  end

  test "render a deletable adult entry component" do
    html = render_surface do
      ~F"""
      <AdultEntry
        id={"adult-0-0"}
        adult={%{}}
        index={0}
        address_index={0}
        can_delete={true} />
      """
    end

    assert html =~ "Adult"
    assert html =~ "First Name"
    assert html =~ "Last Name"
    assert html =~ "Email"
    assert html =~ "Mobile Phone"
    assert html =~ "Remove Adult"
    assert html =~ "phx-click=\"delete_adult\""
  end
end
