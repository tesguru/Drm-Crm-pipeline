defmodule DomainOutreach.Workers.SendInitialEmailWorker do
  use Oban.Worker, queue: :emails, max_attempts: 3

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"campaign_email_id" => id}}) do
    Logger.info("📧 Calling Laravel for email #{id}")
    url = "#{laravel_url()}/internal/send-initial?campaign_email_id=#{id}"

    case HTTPoison.get(
      url,
      [{"Content-Type", "application/json"}],
      recv_timeout: 60_000,   # ← 60s
      timeout: 65_000,
      ssl: [verify: :verify_peer, cacerts: :public_key.cacerts_get()]
    ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info("✅ Email #{id} sent! Response: #{body}")
        :ok

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        Logger.error("❌ 404 Email #{id} not found: #{body}")
        {:cancel, "Email not found"}

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        Logger.error("❌ 400 Bad request for email #{id}: #{body}")
        {:cancel, body}

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Logger.error("❌ #{code} Unexpected for email #{id}: #{body}")
        {:error, body}

      {:error, reason} ->
        Logger.error("❌ Network error for email #{id}: #{inspect(reason)}")
        {:error, inspect(reason)}
    end
  end

  defp laravel_url do
    Application.get_env(:domain_outreach, :laravel_url)
  end
end