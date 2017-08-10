defmodule NeverBounceExTest do
  use ExUnit.Case
  doctest NeverBounceEx

  test "greets the world" do
    assert NeverBounceEx.hello() == :world
  end
end
