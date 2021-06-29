defmodule StudentListWeb.UserRegistrationControllerTest do
  use StudentListWeb.ConnCase, async: true

  import StudentList.AccountsFixtures

  describe "GET /users/register with existing user" do
    setup do
      %{user: user_fixture()}
    end

    test "doesn't render registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = text_response(conn, 404)
      assert response =~ "Not found"
    end
  end

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Login"
      assert response =~ "Register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/admin"
    end
  end

  describe "POST /users/register with existing user" do
    @tag :capture_log
    setup do
      %{user: user_fixture()}
    end

    test "doesn't create account", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes(email: email)
        })

      response = text_response(conn, 404)
      assert response =~ "Not found"
      refute get_session(conn, :user_token)
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/admin"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/admin")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings"
      assert response =~ "Logout"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
