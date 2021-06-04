defmodule StudentListWeb.AdultControllerTest do
  use StudentListWeb.ConnCase

  alias StudentList.Directory

  setup :register_and_log_in_user

  @create_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", mobile_phone: "some mobile_phone"}
  @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", mobile_phone: "some updated mobile_phone"}
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil, mobile_phone: nil}

  def fixture(:adult) do
    {:ok, adult} = Directory.create_adult(@create_attrs)
    adult
  end

  test "redirects if user is not logged in" do
    conn = build_conn()
    conn = get(conn, Routes.adult_path(conn, :index))
    assert redirected_to(conn) == Routes.user_session_path(conn, :new)
  end

  describe "index" do
    test "lists all adults", %{conn: conn} do
      conn = get conn, Routes.adult_path(conn, :index)
      assert html_response(conn, 200) =~ "Adults"
    end
  end

  describe "new adult" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.adult_path(conn, :new)
      assert html_response(conn, 200) =~ "New Adult"
    end
  end

  describe "create adult" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.adult_path(conn, :create), adult: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.adult_path(conn, :show, id)

      conn = get conn, Routes.adult_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Adult Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.adult_path(conn, :create), adult: @invalid_attrs
      assert html_response(conn, 200) =~ "New Adult"
    end
  end

  describe "edit adult" do
    setup [:create_adult]

    test "renders form for editing chosen adult", %{conn: conn, adult: adult} do
      conn = get conn, Routes.adult_path(conn, :edit, adult)
      assert html_response(conn, 200) =~ "Edit Adult"
    end
  end

  describe "update adult" do
    setup [:create_adult]

    test "redirects when data is valid", %{conn: conn, adult: adult} do
      conn = put conn, Routes.adult_path(conn, :update, adult), adult: @update_attrs
      assert redirected_to(conn) == Routes.adult_path(conn, :show, adult)

      conn = get conn, Routes.adult_path(conn, :show, adult)
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, adult: adult} do
      conn = put conn, Routes.adult_path(conn, :update, adult), adult: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Adult"
    end
  end

  describe "delete adult" do
    setup [:create_adult]

    test "deletes chosen adult", %{conn: conn, adult: adult} do
      conn = delete conn, Routes.adult_path(conn, :delete, adult)
      assert redirected_to(conn) == Routes.adult_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.adult_path(conn, :show, adult)
      end
    end
  end

  defp create_adult(_) do
    adult = fixture(:adult)
    {:ok, adult: adult}
  end
end
