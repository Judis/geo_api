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

  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, ensure: true
end
