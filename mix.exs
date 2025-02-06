defmodule GenserverCapslock.MixProject do
  use Mix.Project

  def project do
    [
      app: :genserver_capslock,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GenserverCapslock.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bandit, "~> 1.5"},
      {:dns_cluster, "~> 0.1.1"},
      {:ecto_sql, "~> 3.10"},
      {:finch, "~> 0.13"},
      {:gettext, "~> 0.26"},
      {:hackney, "~> 1.8"},
      {:heroicons,
       github: "tailwindlabs/heroicons", tag: "v2.1.1", sparse: "optimized", app: false, compile: false, depth: 1},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.7.19"},
      {:phoenix_ecto, "~> 4.5"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_live_view, "~> 1.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:sentry, "~> 10.2.0"},
      {:swoosh, "~> 1.5"},

      # dev
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:styler, "~> 1.0.0", only: :dev, runtime: false},

      # test
      {:floki, ">= 0.30.0", only: :test},

      # Telemetry and metrics
      {:opentelemetry, "~> 1.0"},
      {:opentelemetry_api, "~> 1.0"},
      {:opentelemetry_cowboy, "~> 0.3"},
      {:opentelemetry_ecto, "~> 1.0"},
      {:opentelemetry_exporter, "~> 1.0"},
      {:opentelemetry_phoenix, "~> 1.0"},
      {:opentelemetry_req, "~> 0.2"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind genserver_capslock", "esbuild genserver_capslock"],
      "assets.deploy": [
        "tailwind genserver_capslock --minify",
        "esbuild genserver_capslock --minify",
        "phx.digest"
      ]
    ]
  end
end
