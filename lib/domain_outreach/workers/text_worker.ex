defmodule DomainOutreach.Workers.TestWorker do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"message" => message}}) do
    IO.puts("============================")
    IO.puts("✅ OBAN IS WORKING!")
    IO.puts("📨 Message: #{message}")
    IO.puts("⏰ Time: #{DateTime.utc_now()}")
    IO.puts("============================")
    :ok
  end
end