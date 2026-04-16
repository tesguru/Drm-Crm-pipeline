import Config

config :domain_outreach, DomainOutreach.Repo,
  username: "mac",
  password: "",
  hostname: "localhost",
  database: "dm-crm",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :domain_outreach,
  laravel_url: "https://dnwhouse.com"

config :domain_outreach, DomainOutreachWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "/jXQ33HjQbb79VoPKrcGiAjKFBqvjAVTj0xE4T3fGTwPWpGHYZJD3JrelJV1z9aQ",
  watchers: []

config :domain_outreach, DomainOutreachWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*\.(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*\.po$",
      ~r"lib/domain_outreach_web/router\.ex$",
      ~r"lib/domain_outreach_web/(controllers|live|components)/.*\.(ex|heex)$"
    ]
  ]

config :domain_outreach, dev_routes: true

config :logger, :default_formatter, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false