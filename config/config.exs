# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :adventure,
  ecto_repos: [Adventure.Repo]

# Configures the endpoint
config :adventure, AdventureWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AiE+n17HEF3gCj6xgcAexbEIW4YuoTzf5HAycVJL6p8MKi59n5grg6tY2pX8U8go",
  render_errors: [view: AdventureWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Adventure.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures floki
# https://github.com/philss/floki
config :floki, :html_parser, Floki.HTMLParser.Html5ever

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
