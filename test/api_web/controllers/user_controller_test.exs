defmodule GeoApiWeb.UserControllerTest do
  use GeoApiWeb.ConnCase

  alias GeoApi.Account
  alias GeoApi.Account.User

  @auth_attrs %{email: "test@test.com", name: "Auth User", password: "SomeValidPassw0rd"}
  @create_attrs %{email: "test1@test.com", name: "some name", password: "SomeNewPassw0rd"}
  @update_attrs %{email: "test2@test.com", name: "some updated name", password: "Some0therPa22word"}
  @invalid_attrs %{email: nil, name: nil, password_hash: nil}


  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} = config do
    cond do
      config[:authenticated] ->
        conn = put_req_header(conn, "accept", "application/json")
        {:ok, user} = GeoApi.Account.create_user(@auth_attrs)
        {:ok, jwt, _full_claims} = GeoApi.Guardian.encode_and_sign(user)
        {:ok, conn: conn, jwt: jwt}
      true ->
        {:ok, conn: conn, jwt: nil}
    end
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :authenticated
    test "lists all users", %{conn: conn, jwt: jwt} do
      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(user_path(conn, :index))
      user_list = json_response(response, 200)["data"]
      [user] = user_list

      assert length(user_list) == 1
      assert user["email"] == @auth_attrs[:email]
    end
  end

  describe "create user" do
    @tag :authenticated
    test "renders user when data is valid", %{conn: conn, jwt: jwt} do
      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> post(user_path(conn, :create), user: @create_attrs)

      assert %{"id" => id} = json_response(response, 201)["data"]


      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(user_path(conn, :show, id))
      user = json_response(response, 200)["data"]
      assert user["email"] == "test1@test.com"
      assert user["name"] == "some name"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, jwt: jwt} do
      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> post(user_path(conn, :create), user: @invalid_attrs)
      assert json_response(response, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag :authenticated
    test "renders user when data is valid", %{conn: conn, jwt: jwt, user: %User{id: id} = user} do
      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put(user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(response, 200)["data"]

      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(user_path(conn, :show, id))

      user = json_response(response, 200)["data"]
      assert user["email"] == "test2@test.com"
      assert user["name"] == "some updated name"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, jwt: jwt, user: user} do
      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put(user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(response, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    @tag :authenticated
    test "deletes chosen user", %{conn: conn, jwt: jwt, user: user} do
      response = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete(user_path(conn, :delete, user))
      assert response(response, 204)

      assert_error_sent 404, fn ->
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
