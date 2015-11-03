# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :eightyfour,
  credentials: "priv/google_token/token.json",
  private_key: "priv/google_token/token.key.pem",
  # find your view_id in your analytics url:
  # https://www.google.com/analytics/web/#management/Settings/a000w000pVIEW_ID/
  google_view_id: "XXXXXXXX",
  start_date: "2010-01-01",
  token_lifetime: 3600,
  token_provider: Eightyfour.AccessToken
