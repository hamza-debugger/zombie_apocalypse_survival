# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :zombie_apocalypse_survival,
  ecto_repos: [ZombieApocalypseSurvival.Repo]

# Configures the endpoint
config :zombie_apocalypse_survival, ZombieApocalypseSurvivalWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ZombieApocalypseSurvivalWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ZombieApocalypseSurvival.PubSub,
  live_view: [signing_salt: "9njU3PUX"]


config :zombie_apocalypse_survival, ZombieApocalypseSurvival.Auth.Guardian,
       issuer: "zombie_apocalypse_survival",
       secret_key: "vrca2Omb9r1uIfWsEMOw+p+6Ls80EDXFDPbnKWlGlKZ122n+q2sKmQlTLr38su4x" # put the result of the mix command above here


config :bodyguard,
# The second element of the {:error, reason} tuple returned on auth failure
default_error: :unauthorized


config :waffle,
       storage: Waffle.Storage.Local,
      #  storage_dir_prefix: "priv/waffle/private",
       asset_host: {:system, "ASSET_HOST"} # or {:system, "ASSET_HOST"}
# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :zombie_apocalypse_survival, ZombieApocalypseSurvival.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
