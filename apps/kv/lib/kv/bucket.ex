defmodule KV.Bucket do
  use Agent, restart: :temporary

  @doc """
  Starts a new bucket
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from a bucket by key
  """
  def get(bucket, key) do
    Agent.get(bucket, fn map -> Map.get(map, key) end)
  end

  @doc """
  Puts the value for a given key in the bucket
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Deletes key from bucket

  Returns the current value of key, if key exists
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
