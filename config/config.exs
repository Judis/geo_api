# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  namespace: GeoApi,
  ecto_repos: [GeoApi.Repo]

# Configures the endpoint
config :api, GeoApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/UUuGrRoaAKpT+s2evq8NHNpAEfJVplemAwkQpDa8CFCCmNl/n7KX51xJrWD4xVk",
  render_errors: [view: GeoApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GeoApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
