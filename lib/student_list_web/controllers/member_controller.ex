defmodule StudentListWeb.MemberController do
  use StudentListWeb, :controller

  alias StudentList.Accounts
  alias StudentList.Accounts.User

  
  plug(:put_root_layout, {StudentListWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)
  

  def index(conn, params) do
    case Accounts.paginate_members(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Users. #{inspect(error)}")
        |> redirect(to: Routes.member_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_member(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => member_params}) do
    case Accounts.create_member(member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.member_path(conn, :show, member))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member = Accounts.get_member!(id)
    render(conn, "show.html", member: member)
  end

  def edit(conn, %{"id" => id}) do
    member = Accounts.get_member!(id)
    changeset = Accounts.change_member(member)
    render(conn, "edit.html", member: member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => member_params}) do
    member = Accounts.get_member!(id)

    case Accounts.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.member_path(conn, :show, member))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", member: member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Accounts.get_member!(id)
    {:ok, _member} = Accounts.delete_member(member)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.member_path(conn, :index))
  end
end
