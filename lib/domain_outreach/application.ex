defmodule DomainOutreach.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DomainOutreach.Repo,
      {Oban, Application.fetch_env!(:domain_outreach, Oban)},
      DomainOutreachWeb.Endpoint
    ]

    opts = [
      strategy: :one_for_one,
      name: DomainOutreach.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    DomainOutreachWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end