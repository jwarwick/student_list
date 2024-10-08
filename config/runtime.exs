import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it typically used load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :student_list, StudentList.Repo,
    ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
    # Gigalixir and Heroku aren't able to connect to provisioned databases with this set
    # socket_options: [:inet6]

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host =
    System.get_env("HOST") ||
      raise """
      environment variable HOST is missing.
      It should be the FQDN where the content is served.
      """

  config :student_list, StudentListWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    url: [host: host],
    secret_key_base: secret_key_base,
    check_origin: ["//*.#{host}"]

  mailgun_api_key =
    System.get_env("MAILGUN_API_KEY") ||
      raise """
      environment variable MAILGUN_API_KEY is missing.
      You can generate one via the Mailgun service
      """

  mailgun_domain =
    System.get_env("MAILGUN_DOMAIN") ||
      raise """
      environment variable MAILGUN_DOMAIN is missing.
      You can generate one via the Mailgun service
      """

  config :student_list, StudentList.Accounts.Mailer,
    adapter: Bamboo.MailgunAdapter,
      api_key: mailgun_api_key,
      domain: mailgun_domain,
      hackney_opts: [
        recv_timeout: :timer.minutes(1)
      ]

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :student_list, StudentListWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.
end
