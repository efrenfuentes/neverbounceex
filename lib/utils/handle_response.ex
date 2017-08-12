defmodule Utils.HandleResponse do
  @moduledoc """
  Utilities functions to parse httpoison json responses
  """

  @doc """
  Parse httpoison json responses
  """
  def response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def response({:ok, %{body: body}}) do
    {:error, Poison.Parser.parse!(body)}
  end
  
  def response({:error, _}) do
    {:error, nil}
  end

end
