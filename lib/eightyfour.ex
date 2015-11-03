defmodule Eightyfour do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Eightyfour.TokenCache, [])
    ]

    opts = [strategy: :one_for_one, name: Eightyfour.Supervisor]
    {:ok, _pid} =  Supervisor.start_link(children, opts)
  end
end