defmodule GeoApiWeb.SessionControllerTest do
  use GeoApiWeb.ConnCase

  alias GeoApi.Account

  @invalid_email %{email: "test", password: "SomeValidPassw0rd"}
  @invalid_password %{email: "test@test.com", password: "SomeInvalidPassword"}
  @valid_credentials %{email: "test@test.com", password: "SomeValidPassw0rd"}
  @user %{email: "test@test.com", name: "Valid Name", password: "SomeValidPassw0rd"}

  def fixture(:user) do
    {:ok, user} = Account.create_user(@user)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_in" do
    setup [:create_user]

    test "show error if email is invalid", %{conn: conn} do
      response = post(conn, session_path(conn, :sign_in), session: @invalid_email)
      errors = json_response(response, 401)["errors"]

      assert errors["detail"] == "Unauthorized"
    end

    test "show error if password is invalid", %{conn: conn} do
      response = post(conn, session_path(conn, :sign_in), session: @invalid_password)
      errors = json_response(response, 401)["errors"]

      assert errors["detail"] == "Unauthorized"
    end

    test "return user and jwt if credentials is valid", %{conn: conn} do
      response = post(conn, session_path(conn, :sign_in), session: @valid_credentials)
      body = json_response(response, 200)
      data = body["data"]

      assert body["status"] == "ok"
      assert body["message"] == "You are successfully logged in! Add this token to authorization header to make authorized requests."
      assert data["email"] == @valid_credentials[:email]
      assert String.length(data["token"]) > 0
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
