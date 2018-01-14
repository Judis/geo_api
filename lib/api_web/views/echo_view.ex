defmodule GeoApiWeb.EchoView do
  use GeoApiWeb, :view

  def render("index.json", _assiments) do
    %{
      success: true
    }
  end
end