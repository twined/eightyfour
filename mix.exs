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
     files: ["config", "lib", "test", "CHANGELOG.md", "LICENSE", "mix.exs", "README.md"],
     links: %{github: "https://github.com/twined/eightyfour"}
    ]
end

  # Dependencies
  defp deps do
    [{:poison, "~> 1.5 or ~> 2.0 or ~> 3.0"},
     {:httpoison, "~> 0.8"},
     {:json_web_token, "~> 0.2"},
     {:timex, "~> 3.0"},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
