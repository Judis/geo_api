defmodule GeoApiWeb.RegistartionControllerTest do
  use GeoApiWeb.ConnCase

  @invalid_email %{email: "test", name: "Valid Name", password: "SomeValidPassw0rd"}
  @short_password %{email: "test@test.com", name: "Valid Name", password: "Sh0rt"}
  @invalid_password %{email: "test@test.com", name: "Valid Name", password: "SomeInvalidPassword"}
  @invalid_name %{email: "test@test.com", name: nil, password: "SomeValidPassw0rd"}
  @valid_attrs %{email: "test@test.com", name: "Valid Name", password: "SomeValidPassw0rd"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_up" do
    test "show error if email is invalid", %{conn: conn} do
      response = post(conn, registration_path(conn, :sign_up), user: @invalid_email)
      errors = json_response(response, 422)["errors"]

      assert errors["email"] == ["has invalid format", "should be at least 5 character(s)"]
    end

    test "show error if password is short", %{conn: conn} do
      response = post(conn, registration_path(conn, :sign_up), user: @short_password)
      errors = json_response(response, 422)["errors"]

      assert errors["password"] == ["should be at least 8 character(s)"]
    end

    test "show error if password not contain number", %{conn: conn} do
      response = post(conn, registration_path(conn, :sign_up), user: @invalid_password)
      errors = json_response(response, 422)["errors"]

      assert errors["password"] == ["Must include at least one lowercase letter, one uppercase letter, and one digit"]
    end

    test "show error if name is not defined", %{conn: conn} do
      response = post(conn, registration_path(conn, :sign_up), user: @invalid_name)
      errors = json_response(response, 422)["errors"]

      assert errors["name"] == ["can't be blank"]
    end

    test "create user with valid credentials", %{conn: conn} do
      response = post(conn, registration_path(conn, :sign_up), user: @valid_attrs)
      |> json_response(201)

      assert response["status"] == "ok"
      assert response["message"] == "  Now you can sign in using your email and password at /api/sign_in. You will receive JWT token.\n  Please put this token into Authorization header for all authorized requests.\n"
    end

    test "show error if email in use", %{conn: conn} do
      post(conn, registration_path(conn, :sign_up), user: @valid_attrs)
      response = post(conn, registration_path(conn, :sign_up), user: @valid_attrs)
      errors = json_response(response, 422)["errors"]

      assert errors["email"] == ["has already been taken"]
    end
  end
end
