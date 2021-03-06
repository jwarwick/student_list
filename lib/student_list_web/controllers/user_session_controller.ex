defmodule StudentListWeb.UserSessionController do
  use StudentListWeb, :controller

  alias StudentList.Accounts
  alias StudentListWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil, can_register: Accounts.can_register())
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", can_register: Accounts.can_register(), error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
