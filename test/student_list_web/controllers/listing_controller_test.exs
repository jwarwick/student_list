defmodule StudentListWeb.ListingControllerTest do
  use StudentListWeb.ConnCase
  alias Plug.Conn

  setup :register_and_log_in_user

  test "redirects if user is not logged in" do
    conn = build_conn()
    conn = get(conn, Routes.listing_path(conn, :index))
    assert redirected_to(conn) == Routes.user_session_path(conn, :new)
  end

  test "redirects download if user is not logged in" do
    conn = build_conn()
    conn = get(conn, Routes.listing_path(conn, :download))
    assert redirected_to(conn) == Routes.user_session_path(conn, :new)
  end

  describe "index" do
    test "creates directory listing", %{conn: conn} do
      conn = get conn, Routes.listing_path(conn, :index)
      assert html_response(conn, 200) =~ "Student Directory"
    end
  end

  describe "download" do
    test "downloads file", %{conn: conn} do
      conn = get conn, Routes.listing_path(conn, :download)
      assert Conn.get_resp_header(conn, "content-type") == ["application/rtf; charset=utf-8"]
      assert conn.status == 200
      assert conn.resp_body =~ "\\rtf"
    end
  end
end
