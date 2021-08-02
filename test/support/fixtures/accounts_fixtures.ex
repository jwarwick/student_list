defmodule StudentList.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StudentList.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> StudentList.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a member.
  """
  def member_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> StudentList.Accounts.register_user()

    user
    # {:ok, member} =
    #   attrs
    #   |> Enum.into(%{
    #     confirmed_at: ~N[2021-05-18 19:18:00],
    #     email: "some email"
    #   })
    #   |> StudentList.Accounts.create_member()

    # member
  end
end
