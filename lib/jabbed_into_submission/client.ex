defmodule JabbedIntoSubmission.Client do
  use HTTPoison.Base

  def process_url(url) do
    Application.get_env(:jabbed_into_submission, :base_url) <> url
  end

  # Try to process the body as JSON, but ejabberd doesn't always return
  # valid JSON, even though it always returns a JSON header.
  def process_response_body(body) do
    with {:ok, json} <- Poison.decode(body) do
      json
    else
      _ -> body
    end
  end
end
