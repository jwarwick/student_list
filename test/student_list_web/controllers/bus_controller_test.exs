defmodule StudentListWeb.BusControllerTest do
  use StudentListWeb.ConnCase

  alias StudentList.Directory

  @create_attrs %{display_order: 42, name: "some name", should_display: true}
  @update_attrs %{display_order: 43, name: "some updated name", should_display: false}
  @invalid_attrs %{display_order: nil, name: nil, should_display: nil}

  def fixture(:bus) do
    {:ok, bus} = Directory.create_bus(@create_attrs)
    bus
  end

  describe "index" do
    test "lists all buses", %{conn: conn} do
      conn = get conn, Routes.bus_path(conn, :index)
      assert html_response(conn, 200) =~ "Buses"
    end
  end

  describe "new bus" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.bus_path(conn, :new)
      assert html_response(conn, 200) =~ "New Bus"
    end
  end

  describe "create bus" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.bus_path(conn, :create), bus: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.bus_path(conn, :show, id)

      conn = get conn, Routes.bus_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Bus Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.bus_path(conn, :create), bus: @invalid_attrs
      assert html_response(conn, 200) =~ "New Bus"
    end
  end

  describe "edit bus" do
    setup [:create_bus]

    test "renders form for editing chosen bus", %{conn: conn, bus: bus} do
      conn = get conn, Routes.bus_path(conn, :edit, bus)
      assert html_response(conn, 200) =~ "Edit Bus"
    end
  end

  describe "update bus" do
    setup [:create_bus]

    test "redirects when data is valid", %{conn: conn, bus: bus} do
      conn = put conn, Routes.bus_path(conn, :update, bus), bus: @update_attrs
      assert redirected_to(conn) == Routes.bus_path(conn, :show, bus)

      conn = get conn, Routes.bus_path(conn, :show, bus)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, bus: bus} do
      conn = put conn, Routes.bus_path(conn, :update, bus), bus: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Bus"
    end
  end

  describe "delete bus" do
    setup [:create_bus]

    test "deletes chosen bus", %{conn: conn, bus: bus} do
      conn = delete conn, Routes.bus_path(conn, :delete, bus)
      assert redirected_to(conn) == Routes.bus_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.bus_path(conn, :show, bus)
      end
    end
  end

  defp create_bus(_) do
    bus = fixture(:bus)
    {:ok, bus: bus}
  end
end
