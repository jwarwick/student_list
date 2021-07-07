defmodule StudentListWeb.ConfirmationTest do
  use StudentListWeb.ConnCase
  use Surface.LiveViewTest

  alias StudentListWeb.Live.Confirmation

  @endpoint Endpoint

  test "render a confirmation component" do
    html = render_surface do
      ~F"""
      <Confirmation />
      """
    end

    assert html =~ "Thanks for submitting your info!!!"
  end
end
