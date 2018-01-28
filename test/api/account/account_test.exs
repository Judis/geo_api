defmodule GeoApi.AccountTest do
  use GeoApi.DataCase

  alias GeoApi.Account

  describe "users" do
    alias GeoApi.Account.User

    @valid_attrs %{email: "test1@test.com", name: "some name", password: "SomeNewPassw0rd"}
    @update_attrs %{email: "test2@test.com", name: "some updated name", password: "Some0therPa22word"}
    @invalid_attrs %{email: nil, name: nil, password_hash: nil}
    @invalid_email_attr %{email: "test", name: "some name", password_hash: "SomeNewPassw0rd"}
    @invalid_password_attr %{email: "test1@test.com", name: "some name", password_hash: "password"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = Map.put(user_fixture(), :password, nil)
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = Map.put(user_fixture(), :password, nil)
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "test1@test.com"
      assert user.name == "some name"
      assert Comeonin.Bcrypt.checkpw("SomeNewPassw0rd", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid email returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_email_attr)
    end

    test "create_user/1 with invalid password returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_password_attr)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "test2@test.com"
      assert user.name == "some updated name"
      assert Comeonin.Bcrypt.checkpw("Some0therPa22word", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = Map.put(user_fixture(), :password, nil)
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "update_user/2 with invalid email returns error changeset" do
      user = Map.put(user_fixture(), :password, nil)
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_email_attr)
      assert user == Account.get_user!(user.id)
    end

    test "update_user/2 with invalid password returns error changeset" do
      user = Map.put(user_fixture(), :password, nil)
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_password_attr)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end

    test "find_and_confirm_user/2 returns the user with given email" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.find_and_confirm_user(user.email, user.password)
      assert user.email == "test1@test.com"
      assert user.name == "some name"
    end

    test "find_and_confirm_user/2 returns the :unauthorized error if user is not found" do
      assert {:error, :unauthorized} = Account.find_and_confirm_user("wrong_user@test.com", "wrong_password")
    end

    test "find_and_confirm_user/2 returns the :unauthorized error if password is incorect" do
      user = user_fixture()
      assert {:error, :unauthorized} = Account.find_and_confirm_user(user.email, "wrong_password")
    end
  end
end
