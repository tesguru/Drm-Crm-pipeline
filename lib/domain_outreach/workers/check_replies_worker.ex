defmodule DomainOutreach.Workers.CheckRepliesWorker do
  use Oban.Worker,
    queue: :reply_checks,
    max_attempts: 3

  alias DomainOutreach.Repo
  alias DomainOutreach.Campaigns
  alias DomainOutreach.Campaigns.{Campaign, CampaignEmail}
  alias DomainOutreach.Gmail.GmailService
  import Ecto.Query

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"campaign_id" => id}}) do
    campaign = Repo.get(Campaign, id)

    if is_nil(campaign) do
      {:error, "Campaign not found"}
    else
      check_all_replies(campaign)
    end
  end

  defp check_all_replies(campaign) do
    emails =
      from(e in CampaignEmail,
        where: e.campaign_id == ^campaign.id,
        where: e.status == "sent",
        where: e.has_reply == false,
        where: not is_nil(e.gmail_thread_id),
        preload: [:gmail_account]
      )
      |> Repo.all()

    replies_found =
      emails
      |> Enum.filter(fn email ->
          GmailService.thread_has_reply?(
            email.gmail_account,
            email.gmail_thread_id,
            email.to_email
          )
        end)
      |> Enum.map(fn email ->
          Campaigns.mark_email_replied(email)
          email
        end)
      |> length()

    if replies_found > 0 do
      Campaigns.refresh_stats(campaign)
    end

    {:ok, %{replies_found: replies_found}}
  end
end