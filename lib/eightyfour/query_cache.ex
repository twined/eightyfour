defmodule Eightyfour.QueryCache do
  @moduledoc """
  Caches queries in ETS by @ttl.
  """
  use GenServer
  import Eightyfour.Utils, only: [seconds_since_epoch: 0]

  # 12 hours between fetching.
  @ttl 60 * 60 * 12

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, read_concurrency: true])
    {:ok, {__MODULE__, :ok}}
  end

  def put(query, val) do
    expires = seconds_since_epoch() + @ttl
    :ets.insert(__MODULE__, {query, expires, val})
  end

  def get(query) do
    case :ets.lookup(__MODULE__, query) do
      [] ->
        []
      result ->
        [{_, expires, _}] = result
        if seconds_since_epoch() > expires do
          :ets.delete(__MODULE__, query)
          []
        else
          result
        end
    end
  end
end
