defmodule StudentListWeb.AdultController do
  use StudentListWeb, :controller

  alias StudentList.Directory
  alias StudentList.Directory.Adult

  
  plug(:put_root_layout, {StudentListWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)
  

  def index(conn, params) do
    case Directory.paginate_adults(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Adults. #{inspect(error)}")
        |> redirect(to: Routes.adult_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Directory.change_adult(%Adult{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"adult" => adult_params}) do
    case Directory.create_adult(adult_params) do
      {:ok, adult} ->
        conn
        |> put_flash(:info, "Adult created successfully.")
        |> redirect(to: Routes.adult_path(conn, :show, adult))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    adult = Directory.get_adult!(id)
    render(conn, "show.html", adult: adult)
  end

  def edit(conn, %{"id" => id}) do
    adult = Directory.get_adult!(id)
    changeset = Directory.change_adult(adult)
    render(conn, "edit.html", adult: adult, changeset: changeset)
  end

  def update(conn, %{"id" => id, "adult" => adult_params}) do
    adult = Directory.get_adult!(id)

    case Directory.update_adult(adult, adult_params) do
      {:ok, adult} ->
        conn
        |> put_flash(:info, "Adult updated successfully.")
        |> redirect(to: Routes.adult_path(conn, :show, adult))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", adult: adult, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    adult = Directory.get_adult!(id)
    {:ok, _adult} = Directory.delete_adult(adult)

    conn
    |> put_flash(:info, "Adult deleted successfully.")
    |> redirect(to: Routes.adult_path(conn, :index))
  end
end
