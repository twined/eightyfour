defmodule Eightyfour.Client do
  @moduledoc """
  API client.
  """
  use HTTPoison.Base
  @base_url "https://www.googleapis.com/analytics/v3/data/ga"

  def process_url(url) do
    @base_url <> url
  end

  defp process_request_headers(headers) do
    token = Eightyfour.TokenCache.access_token()
    Enum.into(headers, [
      {"Authorization", "Bearer #{token}"},
      {"Content-type", "application/json"}
    ])
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end

  def api_get(url, params) do
    defs = %{"ids": "ga:#{Application.get_env(:eightyfour, :google_view_id)}"}
    {:ok, %HTTPoison.Response{body: body}} =
      get(url, [], params: Map.merge(params, defs))

    body
  end
end
