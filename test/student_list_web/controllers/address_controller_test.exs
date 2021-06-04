defmodule StudentListWeb.AddressControllerTest do
  use StudentListWeb.ConnCase

  alias StudentList.Directory

  setup :register_and_log_in_user

  @create_attrs %{address1: "some address1", address2: "some address2", city: "some city", phone: "some phone", state: "some state", zip: "some zip"}
  @update_attrs %{address1: "some updated address1", address2: "some updated address2", city: "some updated city", phone: "some updated phone", state: "some updated state", zip: "some updated zip"}
  @invalid_attrs %{address1: nil, address2: nil, city: nil, phone: nil, state: nil, zip: nil}

  def fixture(:address) do
    {:ok, address} = Directory.create_address(@create_attrs)
    address
  end

  test "redirects if user is not logged in" do
    conn = build_conn()
    conn = get(conn, Routes.address_path(conn, :index))
    assert redirected_to(conn) == Routes.user_session_path(conn, :new)
  end

  describe "index" do
    test "lists all addresses", %{conn: conn} do
      conn = get conn, Routes.address_path(conn, :index)
      assert html_response(conn, 200) =~ "Addresses"
    end
  end

  describe "new address" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.address_path(conn, :new)
      assert html_response(conn, 200) =~ "New Address"
    end
  end

  describe "create address" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.address_path(conn, :create), address: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.address_path(conn, :show, id)

      conn = get conn, Routes.address_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Address Details"
    end

    test "redirects when data is empty", %{conn: conn} do
      conn = post conn, Routes.address_path(conn, :create), address: @invalid_attrs
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.address_path(conn, :show, id)

      conn = get conn, Routes.address_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Address Details"
    end
  end

  describe "edit address" do
    setup [:create_address]

    test "renders form for editing chosen address", %{conn: conn, address: address} do
      conn = get conn, Routes.address_path(conn, :edit, address)
      assert html_response(conn, 200) =~ "Edit Address"
    end
  end

  describe "update address" do
    setup [:create_address]

    test "redirects when data is valid", %{conn: conn, address: address} do
      conn = put conn, Routes.address_path(conn, :update, address), address: @update_attrs
      assert redirected_to(conn) == Routes.address_path(conn, :show, address)

      conn = get conn, Routes.address_path(conn, :show, address)
      assert html_response(conn, 200) =~ "some updated address1"
    end

    test "redirects when data is invalid", %{conn: conn, address: address} do
      conn = put conn, Routes.address_path(conn, :update, address), address: @invalid_attrs
      assert redirected_to(conn) == Routes.address_path(conn, :show, address)
    end
  end

  describe "delete address" do
    setup [:create_address]

    test "deletes chosen address", %{conn: conn, address: address} do
      conn = delete conn, Routes.address_path(conn, :delete, address)
      assert redirected_to(conn) == Routes.address_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.address_path(conn, :show, address)
      end
    end
  end

  defp create_address(_) do
    address = fixture(:address)
    {:ok, address: address}
  end
end
