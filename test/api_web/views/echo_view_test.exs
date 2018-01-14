defmodule GeoApiWeb.EchoViewTest do
  use GeoApiWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index.json" do
    assert render(GeoApiWeb.EchoView, "index.json", []) ==
           %{success: true}
  end
end
