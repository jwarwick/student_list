defmodule StudentListWeb.EntryControllerTest do
  use StudentListWeb.ConnCase

  alias StudentList.Directory

  setup :register_and_log_in_user

  @create_attrs %{content: "some content"}

  def fixture(:entry) do
    {:ok, entry} = Directory.create_entry(@create_attrs)
    entry
  end

  describe "index" do
    test "lists all entries", %{conn: conn} do
      conn = get conn, Routes.entry_path(conn, :index)
      assert html_response(conn, 200) =~ "Entries"
    end
  end

  describe "delete entry" do
    setup [:create_entry]

    test "deletes chosen entry", %{conn: conn, entry: entry} do
      conn = delete conn, Routes.entry_path(conn, :delete, entry)
      assert redirected_to(conn) == Routes.entry_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.entry_path(conn, :show, entry)
      end
    end
  end

  defp create_entry(_) do
    entry = fixture(:entry)
    {:ok, entry: entry}
  end
end
