defmodule Tindev.MixProject do
  use Mix.Project

  def project do
    [
      app: :tindev,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:mongodb_driver, :httpoison],
      extra_applications: [:logger, :plug_cowboy],
      mod: {Tindev.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:plug_cowboy, "~> 2.0"},
      {:mongodb_driver, "~> 0.5"},
      {:db_connection, "~> 2.0"},
      {:httpoison, "~> 1.4"},
      {:exsync, "~> 0.2", only: :dev},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
  end
end
