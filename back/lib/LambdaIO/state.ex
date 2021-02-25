defmodule LambdaIO.State do

  @moduledoc """
  --- Game's state ---
  %Player[
    {
      "uuid" => "2130-asdf-12zx-!@z9",
      "x" => 10,
      "y" => 23,
      "score" => 0,
      "health" => 100
    },
    {
      "uuid" => "9651-awwa-12zx-!@z9",
      "x" => 10,
      "y" => 23,
      "score" => 0,
      "health" => 100
    }
  ]
  %Shots[
    {
      "uuid" => "2130-asdf-12zx-!@z9",
      "sid" => "awdawdvb",
      "vector" => [x, y, xt, yt]
    },
    {
      "uuid" => "237rzf",
      "sid" => "468awd54",
      "vector" => [x, y, xt, yt]
    },
  ]
  """

  defstruct players: [], shots: []
end
