defmodule NeverBounceEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :neverbounceex,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {NeverBounceEx, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.1"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
