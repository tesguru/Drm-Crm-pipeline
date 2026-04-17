import Config

config :domain_outreach, DomainOutreachWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Configure Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Req

# Disable Swoosh Local Memory Storage
config :swoosh, local: false
config :domain_outreach, :laravel_url, "http://dnwhouse.com"
# Do not print debug messages in production
config :logger, level: :info