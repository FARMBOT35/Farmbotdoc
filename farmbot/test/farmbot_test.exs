defmodule FarmbotTest do
  use ExUnit.Case
  doctest Farmbot

  test "greets the world" do
    assert Farmbot.hello() == :world
  end
end
