defmodule Eightyfour.Mixfile do
  use Mix.Project

  def project do
    [app: :eightyfour,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies
  defp deps do
    [{:poison, "~> 1.5 or ~> 2.0"},
     {:httpoison, "~> 0.8"},
     {:json_web_token, "~> 0.2"},
     {:timex, "~> 2.1"},
     {:dogma, github: "lpil/dogma", only: :dev}]
  end
end
