use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, GeoApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :api, GeoApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "Judis",
  password: "",
  database: "geo_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :api, GeoApi.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "api",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "test",
  serializer: GeoApi.Guardian

config :bcrypt_elixir, :log_rounds, 4