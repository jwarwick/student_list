defmodule StudentListWeb.ClassController do
  use StudentListWeb, :controller

  alias StudentList.Directory
  alias StudentList.Directory.Class

  
  plug(:put_root_layout, {StudentListWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)
  

  def index(conn, params) do
    case Directory.paginate_classes(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Classes. #{inspect(error)}")
        |> redirect(to: Routes.class_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Directory.change_class(%Class{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"class" => class_params}) do
    case Directory.create_class(class_params) do
      {:ok, class} ->
        conn
        |> put_flash(:info, "Class created successfully.")
        |> redirect(to: Routes.class_path(conn, :show, class))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    class = Directory.get_class!(id)
    render(conn, "show.html", class: class)
  end

  def edit(conn, %{"id" => id}) do
    class = Directory.get_class!(id)
    changeset = Directory.change_class(class)
    render(conn, "edit.html", class: class, changeset: changeset)
  end

  def update(conn, %{"id" => id, "class" => class_params}) do
    class = Directory.get_class!(id)

    case Directory.update_class(class, class_params) do
      {:ok, class} ->
        conn
        |> put_flash(:info, "Class updated successfully.")
        |> redirect(to: Routes.class_path(conn, :show, class))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", class: class, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    class = Directory.get_class!(id)
    {:ok, _class} = Directory.delete_class(class)

    conn
    |> put_flash(:info, "Class deleted successfully.")
    |> redirect(to: Routes.class_path(conn, :index))
  end
end
