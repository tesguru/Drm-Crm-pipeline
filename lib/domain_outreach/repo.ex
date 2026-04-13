defmodule DomainOutreach.Repo do
  use Ecto.Repo,
    otp_app: :domain_outreach,
    adapter: Ecto.Adapters.Postgres
end
