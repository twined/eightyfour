defmodule Eightyfour do
  @moduledoc File.read!("README.md")

  defmodule Error do
    @moduledoc """
    Defines an exception for Eightyfour errors.
    """
    defexception [:message]
  end

  def start_link() do
    import Supervisor.Spec, warn: false

    children = [
      worker(Eightyfour.QueryCache, []),
      worker(Eightyfour.TokenCache, [])
    ]

    opts = [strategy: :one_for_one, name: Eightyfour.Supervisor]
    {:ok, _pid} =  Supervisor.start_link(children, opts)
  end
end
