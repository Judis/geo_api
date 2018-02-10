defmodule GeoApiWeb.EchoController do
  use GeoApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.json"
  end
end
