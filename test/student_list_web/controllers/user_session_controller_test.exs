defmodule StudentListWeb.UserSessionControllerTest do
  use StudentListWeb.ConnCase, async: true

  import StudentList.AccountsFixtures


  describe "GET /users/log_in" do
    setup do
      %{user: user_fixture()}
    end

    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.user_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Login</h1>"
      assert response =~ "Login"
      refute response =~ "Register"
    end

    test "redirects if already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
      assert redirected_to(conn) == "/admin"
    end
  end

  describe "GET /users/log_in if no users exist" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.user_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Login</h1>"
      assert response =~ "Login"
      assert response =~ "Register"
    end
  end

  describe "POST /users/log_in" do
    setup do
      %{user: user_fixture()}
    end

    test "logs the user in", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/admin"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/admin")
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ "Settings"
      assert response =~ "Logout"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_student_list_web_user_remember_me"]
      assert redirected_to(conn) =~ "/admin"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session(user_return_to: "/foo/bar")
        |> post(Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Login</h1>"
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /users/log_out" do
    setup do
      %{user: user_fixture()}
    end

    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/users/log_in"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/users/log_in"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
