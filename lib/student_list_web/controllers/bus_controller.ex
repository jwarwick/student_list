defmodule StudentListWeb.BusController do
  use StudentListWeb, :controller

  alias StudentList.Directory
  alias StudentList.Directory.Bus

  
  plug(:put_root_layout, {StudentListWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)
  

  def index(conn, params) do
    case Directory.paginate_buses(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Buses. #{inspect(error)}")
        |> redirect(to: Routes.bus_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Directory.change_bus(%Bus{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bus" => bus_params}) do
    case Directory.create_bus(bus_params) do
      {:ok, bus} ->
        conn
        |> put_flash(:info, "Bus created successfully.")
        |> redirect(to: Routes.bus_path(conn, :show, bus))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bus = Directory.get_bus!(id)
    render(conn, "show.html", bus: bus)
  end

  def edit(conn, %{"id" => id}) do
    bus = Directory.get_bus!(id)
    changeset = Directory.change_bus(bus)
    render(conn, "edit.html", bus: bus, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bus" => bus_params}) do
    bus = Directory.get_bus!(id)

    case Directory.update_bus(bus, bus_params) do
      {:ok, bus} ->
        conn
        |> put_flash(:info, "Bus updated successfully.")
        |> redirect(to: Routes.bus_path(conn, :show, bus))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bus: bus, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bus = Directory.get_bus!(id)
    {:ok, _bus} = Directory.delete_bus(bus)

    conn
    |> put_flash(:info, "Bus deleted successfully.")
    |> redirect(to: Routes.bus_path(conn, :index))
  end
end
