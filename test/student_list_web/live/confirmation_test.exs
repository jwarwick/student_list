defmodule StudentListWeb.ConfirmationTest do
  use StudentListWeb.ConnCase
  use Surface.LiveViewTest

  alias StudentListWeb.Live.Confirmation

  @endpoint Endpoint

  test "render a confirmation component" do
    html = render_surface do
      ~F"""
      <Confirmation
        students={[]}
      />
      """
    end

    assert html =~ "The information below has been submitted for the school directory."
  end
end
