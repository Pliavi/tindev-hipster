defmodule TindevTest do
  use ExUnit.Case
  doctest Tindev

  test "greets the world" do
    assert Tindev.hello() == :world
  end
end
