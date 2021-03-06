# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :student_list,
  ecto_repos: [StudentList.Repo]

# Configures the endpoint
config :student_list, StudentListWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1EhzVQR09kewC/L2L8VFjp6D4SqrIkbaHXpNial5IxToQaEE5nQLfL1q5DyIiDZv",
  render_errors: [view: StudentListWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: StudentList.PubSub,
  live_view: [signing_salt: "fmqQ4hVV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :torch,
  otp_app: :student_list,
  template_format: "eex" || "slime"

# Configure Bamboo mailer test adapter
config :student_list, StudentList.Accounts.Mailer,
  adapter: Bamboo.SendGrid

# Configure dev environment only flag
config :student_list, :environment, Mix.env()

# Configure Content-Security Policy (CSP)
# override this in prod.ex
config :student_list, :content_security_policy,
"default-src 'self' 'unsafe-eval' 'unsafe-inline';" <>
  "connect-src 'self' ws:;" <>
    "img-src 'self' blob: data:;" <>
      "font-src 'self' blob: data:;"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
