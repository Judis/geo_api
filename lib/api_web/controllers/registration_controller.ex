defmodule GeoApiWeb.RegistrationController do
  use GeoApiWeb, :controller

  alias GeoApi.Account
  alias GeoApi.Account.User

  action_fallback GeoApiWeb.FallbackController

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("success.json", user: user)
    end
  end
end
