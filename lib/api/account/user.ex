defmodule GeoApi.Account.User do
  @moduledoc """
  User entity schema and methods
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias GeoApi.Account.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password_hash])
    |> validate_required([:email, :name, :password_hash])
  end
end
