defmodule GeoApiWeb.SessionController do
  use GeoApiWeb, :controller

  alias GeoApi.Account
  alias GeoApi.Account.User

  action_fallback GeoApiWeb.FallbackController

  def sign_in(conn, %{"session" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- Account.find_and_confirm_user(email, password) do
      {:ok, jwt, _full_claims} = GeoApi.Guardian.encode_and_sign(user)

      conn
      |> render("sign_in.json", user: user, jwt: jwt)
    end
  end

  def sign_in(_conn, _args) do
    {:error, :bad_request}
  end
end
