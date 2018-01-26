defmodule GeoApiWeb.UserControllerTest do
  use GeoApiWeb.ConnCase

  alias GeoApi.Account
  alias GeoApi.Account.User

  @create_attrs %{email: "test1@test.com", name: "some name", password: "SomeNewPassw0rd"}
  @update_attrs %{email: "test2@test.com", name: "some updated name", password: "Some0therPa22word"}
  @invalid_attrs %{email: nil, name: nil, password_hash: nil}


  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} = config do
    cond do
      config[:login] ->
        user = %User{id: 1}
        {:ok, jwt, full_claims} = GeoApi.Guardian.encode_and_sign(user)
        {:ok, %{user: user, jwt: jwt, claims: full_claims}}
        {:ok, conn: conn
                    |> put_req_header("accept", "application/json")
                    |> put_req_header("authorization", "Bearer: #{jwt}")}
      true ->
        :ok
    end
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :login
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    @tag :login
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      user = json_response(conn, 200)["data"]
      assert user["email"] == "test1@test.com"
      assert user["name"] == "some name"
      assert Comeonin.Bcrypt.checkpw("SomeNewPassw0rd", user["password_hash"])
    end

    @tag :login
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag :login
    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      user = json_response(conn, 200)["data"]
      assert user["email"] == "test2@test.com"
      assert user["name"] == "some updated name"
      assert Comeonin.Bcrypt.checkpw("Some0therPa22word", user["password_hash"])
    end

    @tag :login
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    @tag :login
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
