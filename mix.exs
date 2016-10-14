defmodule Eightyfour.Mixfile do
  use Mix.Project

  def project do
    [app: :eightyfour,
     version: "0.1.0",
     elixir: "~> 1.0",
     description: "Barebones Elixir Google Analytics API wrapper",
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger, :httpoison, :poison, :json_web_token, :timex, :tzdata]]
  end

  def package do
    [maintainers: ["Twined Networks"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/twined/eightyfour"}]
end

  # Dependencies
  defp deps do
    [{:poison, "~> 1.5 or ~> 2.0 or ~> 3.0"},
     {:httpoison, "~> 0.8"},
     {:json_web_token, "~> 0.2"},
     {:timex, "~> 3.0"},
     {:dogma, github: "lpil/dogma", only: :dev}]
  end
end
