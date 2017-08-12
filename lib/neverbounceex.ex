defmodule NeverBounceEx.Client do
  @moduledoc """
  NeverBounceEx.Client is NeverBounce API wrapper
  """
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, [name: name])
  end

  def init(:ok) do
    status = read_config()

    status =
      status
      |> Map.put(:token, get_token(status))

    {:ok, status}
  end

  def handle_call({:timeout}, _from, status) do
    {:reply, status[:timeout], status}
  end

  def handle_call({:single, email}, _from, status) do
    result = single(status, email)

    # if token is invalid get new token
    status = if result == {:error, "Authentication failed"} do
               status
               |> Map.put(:token, get_token(status))
             else
               status
             end

    # if token is invalid try again after refresh token
    result = if result == {:error, "Authentication failed"} do
               single(status, email)
             else
               result
             end

    {:reply, result, status}
  end

  ##############################################################################
  # Support fnctions
  ##############################################################################

  @doc """
  Read username from config
  """
  defp get_username do
    Application.get_env(:neverbounceex, :username)
  end

  @doc """
  Read secret_key from config
  """
  defp get_secret_key do
    Application.get_env(:neverbounceex, :secret_key)
  end

  @doc """
  Read base_url from config or use https://api.neverbounce.com/v3/ as default
  """
  defp get_base_url do
    Application.get_env(:neverbounceex, :base_url) || "https://api.neverbounce.com/v3/"
  end

  @doc """
  Read timeout from config or use 50_000 as default
  """
  defp get_timeout do
    Application.get_env(:neverbounceex, :timeout) || 50_000
  end

  @doc """
  Read config
  """
  defp read_config do
    %{
      username: get_username(),
      secret_key: get_secret_key(),
      base_url: get_base_url(),
      timeout: get_timeout()
    }
  end

  @doc """
  Encode username and secret_key to use them as request header authorization
  """
  defp authorization(config) do
    Base.encode64("#{config[:username]}:#{config[:secret_key]}")
  end

  @doc """
  Get the url for request a specific action :access_token or :single
  """
  defp url(config, action) do
     config[:base_url] <> to_string(action)
  end

  @doc """
  Call NeverBBounce API passing body and headerds
  """
  defp api_call(config, url, body, headers) do
    opts = [{:timeout, config[:timeout]}, {:recv_timeout, config[:timeout]}]

    HTTPoison.post(url, body, headers, opts)
    |> Utils.HandleResponse.response
  end

  @doc """
  Get a token from NeverBounce API
  """
  defp get_token(config) do
    # prepare api request
    url = url(config, :access_token)
    authorization = authorization(config)
    body = "{\"grant_type\": \"client_credentials\", \"scope\": \"basic user\"}"
    headers = [{"Content-Type", "application/json"}, {"Authorization", "Basic #{authorization}"}]

    {status, data} = api_call(config, url, body, headers)
    if status == :ok do
      data["access_token"]
    end
  end

  @doc """
  Convert numeric result to human readable result
  """
  defp result_to_string(result) do
    case result do
      0 -> "valid"
      1 -> "invalid"
      2 -> "disposable"
      3 -> "catchall"
      _ -> "unknown"
    end
  end

  @doc """
  Validate a single email in NeverBounce API
  """
  defp single(config, email) do
    # prepare api request
    url = url(config, :single)
    body = {:form, [access_token: config[:token], email: email]}
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

    {status, data} = api_call(config, url, body, headers)
    if status == :ok do
      if data["success"] do
        {:ok, result_to_string(data["result"])}
      else
        {:error, data["msg"]}
      end
    else
      # we don't get an api response
      {:error, "Network Error"}
    end
  end
end
