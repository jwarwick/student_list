defmodule StudentListWeb.ListingControllerTest do
  use StudentListWeb.ConnCase

  setup :register_and_log_in_user

  test "redirects if user is not logged in" do
    conn = build_conn()
    conn = get(conn, Routes.listing_path(conn, :index))
    assert redirected_to(conn) == Routes.user_session_path(conn, :new)
  end

  describe "index" do
    test "lists all listings", %{conn: conn} do
      conn = get conn, Routes.listing_path(conn, :index)
      assert html_response(conn, 200) =~ "Student Directory"
    end
  end
end
