# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tixdrop,
  ecto_repos: [Tixdrop.Repo]

# Configures the endpoint
config :tixdrop, TixdropWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M9ghoXnnfyY/jgsZOVyjbGp/A4zRQ78qTGXY/Nrb+N7N2Xbux8mTtWSmjOSyiej2",
  render_errors: [view: TixdropWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tixdrop.PubSub, adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  user_context: Tixdrop.Accounts,
  crypto_module: Comeonin.Argon2,
  token_module: TixdropWeb.Auth.Token

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tixdrop, TixdropWeb.Mailer,
  adapter: Bamboo.LocalAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

