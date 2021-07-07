defmodule StudentListWeb.PageLiveTest do
  use StudentListWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    conn = get(conn, "/")
    disconnected_html = html_response(conn, 200)
    {:ok, _live, connected_html} = live(conn)

    assert disconnected_html =~ "Submit"
    assert connected_html =~ "Submit"
  end

  test "basic rendering", %{conn: conn} do
    {:ok, _live, html} = live(conn, "/")

    assert html =~ "Add your information!"
  end
end
