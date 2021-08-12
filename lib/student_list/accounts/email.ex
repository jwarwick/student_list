defmodule StudentList.Accounts.Email do
  @moduledoc """
  Email templates
  """
  import Bamboo.Email

  alias StudentList.Directory

  defp from_email do
    Directory.support_email() || "support@example.com"
  end

  def email_entry(assigns) do
    email = Directory.support_email()
    if email do
      value = assigns
              |> Map.take([:students, :addresses, :notes])
              |> Jason.encode!()
      new_email(
        to: email,
        from: from_email(),
        subject: "Data Submission",
        html_body: """
        <pre>
        #{value}
        </pre>
        """,
        text_body: "#{value}"
    )
    end
  end

  def confirmation_instructions(user, url) do
    new_email(
      to: user.email,
      from: from_email(),
      subject: "Welcome to StudentList",
      html_body: """
      Hi #{user.email},
      <br>

      You can confirm your account by visiting the URL below:
      <br>

      <a href=#{url}>#{url}</a>
      <br>

      If you didn't create an account with us, please ignore this.
      """,
      text_body: "Confirm your email at #{url}"
    )
  end

  def password_reset_instructions(user, url) do
    new_email(
      to: user.email,
      from: from_email(),
      subject: "Reset Your StudentList Password",
      html_body: """
      Hi #{user.email},
      <br>

      You can reset your password by visiting the URL below:
      <br>

      <a href=#{url}>#{url}</a>
      <br>

      If you didn't request this change, please ignore this.
      """,
      text_body: "Reset your password at #{url}"
    )
  end

  def email_change_instructions(user, url) do
    new_email(
      to: user.email,
      from: from_email(),
      subject: "Change Your StudentList Email",
      html_body: """
      Hi #{user.email},
      <br>

      You can change your email by visiting the URL below:
      <br>

      <a href=#{url}>#{url}</a>
      <br>

      If you didn't request this change, please ignore this.
      """,
      text_body: "Change your email at #{url}"
    )
  end
end
