defmodule LambdaIOTest do
  use ExUnit.Case
  doctest LambdaIO

  test "greets the world" do
    assert LambdaIO.hello() == :world
  end
end
