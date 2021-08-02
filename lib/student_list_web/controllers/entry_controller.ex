defmodule StudentListWeb.EntryController do
  use StudentListWeb, :controller

  alias StudentList.Directory
  
  plug(:put_root_layout, {StudentListWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)
  

  def index(conn, params) do
    case Directory.paginate_entries(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Entries. #{inspect(error)}")
        |> redirect(to: Routes.entry_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Directory.get_entry!(id)
    render(conn, "show.html", entry: entry)
  end

  def delete(conn, %{"id" => id}) do
    entry = Directory.get_entry!(id)
    {:ok, _entry} = Directory.delete_entry(entry)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: Routes.entry_path(conn, :index))
  end
end
