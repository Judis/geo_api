defmodule GeoApiWeb.Router do
  use GeoApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug GeoApi.Guardian.AuthPipeline.JSON
  end

  pipeline :authenticated do
    plug GeoApi.Guardian.AuthPipeline.Authenticate
  end

  scope "/", GeoApiWeb do
    pipe_through :api
    get "/", EchoController, :index
    post "/sign_up", RegistrationController, :sign_up
    post "/sign_in", SessionController, :sign_in

    pipe_through :authenticated
    resources "/users", UserController
  end
end
