defmodule RumblWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RumblWeb.Telemetry,
      RumblWeb.Presence,
      # Start the Endpoint (http/https)
      RumblWeb.Endpoint,
      # Start a worker by calling: RumblWeb.Worker.start_link(arg)
      # {RumblWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RumblWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RumblWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
