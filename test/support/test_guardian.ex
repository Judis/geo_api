defmodule GeoApi.Guardian do
  @moduledoc """
  Guardian logic implementation to implement JWT token support.
  """

  use Guardian, otp_app: :api

  def subject_for_token(%{} = resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :invalid_user}
  end

  def resource_from_claims(%{} = claims) do
    id = claims["sub"]
    resource = %{id: id}
    {:ok,  resource}
  end
  def resource_from_claims(_claims) do
    {:error, :invalid_claims}
  end
end

defmodule GeoApi.Guardian.AuthPipeline.JSON do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :api,
                              module: GeoApi.Guardian,
                              error_handler: GeoApi.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
end

defmodule GeoApi.Guardian.AuthPipeline.Authenticate do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :api,
                              module: GeoApi.Guardian,
                              error_handler: GeoApi.Guardian.AuthErrorHandler

end