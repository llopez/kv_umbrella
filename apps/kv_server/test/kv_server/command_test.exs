defmodule KVServer.CommandTest do
  use ExUnit.Case, async: true
  doctest KVServer.Command

  setup context do
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "creates bucket", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error
    assert KVServer.Command.run({:create, "shopping"}, registry) == {:ok, "OK\r\n"}
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
  end

  test "get bucket key", %{registry: registry} do
    bucket = KV.Registry.create(registry, "shopping")
    KV.Bucket.put(bucket, "milk", 3)
    assert KVServer.Command.run({:get, "shopping", "milk"}, registry) == {:ok, "3\r\nOK\r\n"}
  end

  test "put bucket key", %{registry: registry} do
    bucket = KV.Registry.create(registry, "shopping")
    assert KVServer.Command.run({:put, "shopping", "milk", 4}, registry) == {:ok, "OK\r\n"}
    assert KV.Bucket.get(bucket, "milk") == 4
  end

  test "delete bucket key", %{registry: registry} do
    bucket = KV.Registry.create(registry, "shopping")
    KV.Bucket.put(bucket, "milk", 6)
    assert KV.Bucket.get(bucket, "milk") == 6
    assert KVServer.Command.run({:delete, "shopping", "milk"}, registry) == {:ok, "OK\r\n"}
    assert KV.Bucket.get(bucket, "milk") == nil
  end
end
