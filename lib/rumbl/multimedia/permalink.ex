defmodule Rumbl.Multimedia.Permalink do
  @behaviour Ecto.Type

  @doc """
    The underlying Ecto type
  """
  def type, do: :id

  @doc """
    Called when external data is passed into Ecto
  """
  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end

  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def cast(_) do
    :error
  end

  @doc """
    Called when data is sent to the database
  """
  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  @doc """
    Called when data is loaded from the database
  """
  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end
end
