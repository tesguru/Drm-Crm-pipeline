defmodule DomainOutreachWeb.PageController do
  use DomainOutreachWeb, :controller

  def home(conn, _params) do
    text(conn, "OK")
  end

  def test_oban(conn, _params) do
  %{message: "hello from Laravel!"}
  |> DomainOutreach.Workers.TestWorker.new()
  |> Oban.insert()

  text(conn, "Job inserted! Check your terminal logs.")
end
end