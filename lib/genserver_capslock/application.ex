defmodule GenserverCapslock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :logger.add_handler(:my_sentry_handler, Sentry.LoggerHandler, %{
      config: %{metadata: [:file, :line]}
    })

    :ok = start_otel()

    children = [
      GenserverCapslockWeb.Telemetry,
      GenserverCapslock.Repo,
      {DNSCluster, query: Application.get_env(:genserver_capslock, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GenserverCapslock.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GenserverCapslock.Finch},
      # Start a worker by calling: GenserverCapslock.Worker.start_link(arg)
      # {GenserverCapslock.Worker, arg},
      # Start to serve requests, typically the last entry
      GenserverCapslockWeb.Endpoint,
      GenserverCapslock.GlobalCapslock,
      GenserverCapslockWeb.UserTracker
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenserverCapslock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GenserverCapslockWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @spec start_otel() :: :ok
  def start_otel do
    OpentelemetryEcto.setup([:favicon_cafe, :repo], db_statement: :enabled)
    :opentelemetry_cowboy.setup()
    OpentelemetryPhoenix.setup(adapter: :cowboy2)
  end
end
