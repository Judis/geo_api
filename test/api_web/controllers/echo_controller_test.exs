defmodule GeoApiWeb.EchoControllerTest do
  use GeoApiWeb.ConnCase

  test "index/2 responds with all success: true", %{conn: conn} do
    response = conn
    |> get(echo_path(conn, :index))
    |> json_response(200)

    expected = %{
      "success" => true
    }

    assert response == expected
  end
end