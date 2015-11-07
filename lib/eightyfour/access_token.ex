defmodule Eightyfour.AccessToken do
  @moduledoc """
  Access token helpers
  """
  @type t :: %Eightyfour.AccessToken{token: String.t, expires_in: integer}
  defstruct token: "", expires_in: nil

  alias Eightyfour.Settings, as: Settings
  import Eightyfour.Utils, only: [seconds_since_epoch: 0, one_hour_from_now: 0]

  @header ~s({"alg":"RS256","typ":"JWT"})
  @refresh_url "https://www.googleapis.com/oauth2/v3/token"
  @permissions "https://www.googleapis.com/auth/analytics.readonly"
  @access_token_exchange_url "https://www.googleapis.com/oauth2/v3/token"

  @doc """
  Refresh the auth token
  """
  def refresh do
    form_data = [
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt()
    ]

    {:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.post(
      "https://www.googleapis.com/oauth2/v3/token",
      {:form, form_data}
    )

    token = Poison.decode!(body)

    %Eightyfour.AccessToken{
      token: token["access_token"],
      expires_in: token["expires_in"]
    }
  end

  defp jwt do
    JsonWebToken.sign(claim_set(), %{alg: "RS256", key: private_key()})
  end

  defp private_key do
    path = Settings.private_key_path
    dir = Path.dirname(path)
    key = Path.basename(path)
    JsonWebToken.Algorithm.RsaUtil.private_key(dir, key)
  end

  defp claim_set do
    %{
      iss:   Settings.client_email,
      scope: @permissions,
      aud:   @refresh_url,
      iat:   seconds_since_epoch(),
      exp:   one_hour_from_now()
    }
  end
end
