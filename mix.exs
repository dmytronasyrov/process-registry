defmodule ProcessRegistry.Mixfile do
  use Mix.Project

  def project do
    [app: :process_registry,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ProcessRegistry.Application, []},
      env: [port: 8888]
    ]
  end

  defp deps do
    [
      {:gproc, "~> 0.6"},
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"},
      {:socket, "~> 0.3"}
    ]
  end
end
