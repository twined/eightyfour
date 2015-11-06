defmodule Eightyfour.TokenCache do
  @moduledoc """
  Caches our Google OAuth token
  """
  use GenServer
  alias Eightyfour.AccessToken

  def start_link() do
    GenServer.start_link(__MODULE__, {%AccessToken{}, {}}, name: __MODULE__)
  end

  def access_token() do
    GenServer.call(__MODULE__, :access_token)
  end

  def handle_call(:access_token, _, {%AccessToken{token: ""}, _}) do
    refresh()
  end

  def handle_call(:access_token, _, {access_token = %AccessToken{}, retrieved}) do
    if (token_expired(retrieved, access_token.expires_in)) do
      refresh()
    else
      {:reply, access_token.token, {access_token, retrieved}}
    end
  end

  defp refresh() do
    token = token_provider().refresh()
    retrieved = :os.timestamp
    {:reply, token.token, {token, retrieved}}
  end

  defp token_expired(retrieved, expires_in) do
    now = :os.timestamp
    :timer.now_diff(now, retrieved) >= (expires_in * 1000000)
  end

  defp token_provider do
    Application.get_env(:eightyfour, :token_provider)
  end
end
