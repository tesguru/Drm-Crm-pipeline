defmodule DomainOutreach.Workers.SendFollowUpWorker do
  use Oban.Worker, queue: :follow_ups, max_attempts: 3

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"campaign_email_id" => id}}) do
    Logger.info("📧 Calling Laravel for follow-up #{id}")
    url = "#{laravel_url()}/internal/send-followup?campaign_email_id=#{id}"

    case HTTPoison.get(
      url,
      [{"Content-Type", "application/json"}],
   recv_timeout: 60_000,   # ← 60s
    timeout: 65_000 
      ssl: [verify: :verify_none]
    ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info("✅ Follow-up #{id} sent! Response: #{body}")
        :ok

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        Logger.error("❌ 404 Follow-up #{id} not found: #{body}")
        {:cancel, "Email not found"}

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        Logger.error("❌ 400 Bad request for follow-up #{id}: #{body}")
        {:cancel, body}

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Logger.error("❌ #{code} Unexpected for follow-up #{id}: #{body}")
        {:error, body}

      {:error, reason} ->
        Logger.error("❌ Network error for follow-up #{id}: #{inspect(reason)}")
        {:error, inspect(reason)}
    end
  end

  defp laravel_url do
    Application.get_env(:domain_outreach, :laravel_url)
  end
end