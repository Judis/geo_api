defmodule GeoApiWeb.Router do
  use GeoApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GeoApiWeb do
    pipe_through :api
    get "/", EchoController, :index
    resources "/users", UserController
  end
end
