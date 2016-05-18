defmodule Eightyfour.Settings do
  @moduledoc """
  A centralized place for our settings.

  Fetches from application config as well as the credentials file.
  """
  def client_email,     do: read_config["client_email"]
  def private_key_path, do: Application.get_env(:eightyfour, :private_key)

  defp read_config do
    credentials_file = Application.get_env(:eightyfour, :credentials)

    case File.read(credentials_file) do
      {:ok, json} ->
        Poison.decode!(json)
      {:error, :enoent} ->
        raise Eightyfour.Error,
              message: "Eightyfour credentials file not found. " <>
                       "Make sure it exists in #{credentials_file}"
    end
  end
end
