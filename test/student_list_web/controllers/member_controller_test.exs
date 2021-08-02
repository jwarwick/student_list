defmodule StudentListWeb.MemberControllerTest do
  use StudentListWeb.ConnCase
  use Bamboo.Test

  alias StudentList.Accounts

  setup :register_and_log_in_user

  @create_attrs %{confirmed_at: ~N[2021-05-18 19:18:00], email: "some@example.com", password: "v3RYsecured!1!"}
  @invalid_attrs %{confirmed_at: nil, email: nil}

  def fixture(:member) do
    {:ok, member} = Accounts.create_member(@create_attrs)
    member
  end

  test "redirects if user is not logged in" do
    conn = build_conn()
    conn = get(conn, Routes.member_path(conn, :index))
    assert redirected_to(conn) == Routes.user_session_path(conn, :new)
  end

  describe "index" do
    test "lists all members", %{conn: conn} do
      conn = get conn, Routes.member_path(conn, :index)
      assert html_response(conn, 200) =~ "Members"
    end
  end

  describe "new member" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.member_path(conn, :new)
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "create member" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.member_path(conn, :create), user: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.member_path(conn, :show, id)

      conn = get conn, Routes.member_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Member Details"

      email = @create_attrs.email
      assert_delivered_email_matches(%{to: [{_, ^email}]})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.member_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New Member"
      assert_no_emails_delivered()
    end
  end

  describe "delete member" do
    setup [:create_member]

    test "deletes chosen member", %{conn: conn, user: member} do
      conn = delete conn, Routes.member_path(conn, :delete, member)
      assert redirected_to(conn) == Routes.member_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.member_path(conn, :show, member)
      end
    end
  end

  defp create_member(_) do
    member = fixture(:member)
    {:ok, user: member}
  end
end
