Eightyfour
==========

## Installation

Mix.exs:

```
def application do 
  [applications: [:eightyfour]]
end

defp deps do
  [{:eightyfour, "~> 0.1"}]
end
```

## Usage

Config options:

```elixir
config :eightyfour,
  credentials: "priv/google_token/token.json",
  private_key: "priv/google_token/token.key.pem",
  # find your view_id in your analytics url:
  # https://www.google.com/analytics/web/#management/Settings/a000w000pVIEW_ID/
  google_view_id: "XXXXXX",
  start_date: "2010-01-01",
  token_lifetime: 3600,
  token_provider: Eightyfour.AccessToken
```

Create a Google service account:

* Go to https://console.developers.google.com/
* APIs & auth -> Credentials
* `Add credentials` -> `Service account`
* We need both key types, so start with JSON
* Save as `token.json`
* Click the email address under `Service accounts`.
* `Generate new P12 key`
* Save as `token.p12`
* Move tokens to `priv/google_tokens` under your otp_app.
* `openssl pkcs12 -in token.p12 -out token.crt.pem -clcerts -nokeys`
* `openssl pkcs12 -in token.p12 -out token.key.pem -nocerts -nodes`

Find your google service account's email:

* Go to https://console.developers.google.com/
* APIs & auth -> Credentials
* Copy `Email address` field

Add your google service account's email to the Analytics account you want to track. Make sure that its only permissions are `Read & analyze`.

## Query API examples

```
iex(1)> Eightyfour.Query.browsers(:yesterday)
%{rows: [[os: "Windows", browser: "Chrome", version: "46.0.2490.80", ...]]}
```
