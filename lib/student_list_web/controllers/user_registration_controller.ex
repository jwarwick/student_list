defmodule StudentListWeb.UserRegistrationController do
  use StudentListWeb, :controller

  alias StudentList.Accounts
  alias StudentList.Accounts.User
  alias StudentListWeb.UserAuth

  def new(conn, _params) do
    if Accounts.can_register() do
      changeset = Accounts.change_user_registration(%User{})
      render(conn, "new.html", changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> text("Not found")
    end
  end

  def create(conn, %{"user" => user_params}) do
    if Accounts.can_register() do
      case Accounts.register_user(user_params) do
        {:ok, user} ->
          {:ok, _} =
            Accounts.deliver_user_confirmation_instructions(
              user,
              &Routes.user_confirmation_url(conn, :confirm, &1)
            )

            conn
            |> put_flash(:info, "User created successfully.")
            |> UserAuth.log_in_user(user)

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      conn
      |> put_status(:not_found)
      |> text("Not found")
    end
  end
end
