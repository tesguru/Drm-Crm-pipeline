import Config

config :domain_outreach,
  ecto_repos: [DomainOutreach.Repo],
  generators: [timestamp_type: :utc_datetime]

# Endpoint
config :domain_outreach, DomainOutreachWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [
      html: DomainOutreachWeb.ErrorHTML,
      json: DomainOutreachWeb.ErrorJSON
    ],
    layout: false
  ],
  pubsub_server: DomainOutreach.PubSub,
  live_view: [signing_salt: "fDDWbbba"]

# Mailer
config :domain_outreach, DomainOutreach.Mailer,
  adapter: Swoosh.Adapters.Local

# Esbuild


# Tailwind


# Oban queues
config :domain_outreach, Oban,
  repo: DomainOutreach.Repo,
  queues: [
    default:      100,
    emails:       100,
    follow_ups:   100,
    reply_checks:  50,
    warmup:        50
  ]

# Google OAuth

# HTTPoison
config :httpoison,
  timeout: 30_000,
  recv_timeout: 30_000

import_config "#{config_env()}.exs"