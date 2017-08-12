defmodule NeverBounceEx do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: NeverBounceEx.Worker.start_link(arg)
      # {Neverbounceex.Worker, arg},
      worker(NeverBounceEx.Client, [NeverBounceEx.Client])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neverbounceex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Validate a single email in NeverBounce API
  """
  def single(email) do
    timeout = GenServer.call(NeverBounceEx.Client, {:timeout})
    GenServer.call(NeverBounceEx.Client, {:single, email}, timeout)
  end
end
