defmodule LambdaIO.State do

  @moduledoc """
  --- Players ---
  players: [
    %Player{
      uuid: "2130-asdf-12zx-!@z9",
      x: 200,
      y: 300,
      score: 0
    },
    %Player{
      uuid: "9a!0-4sRz-#2Zx-P*9P",
      x: 100,
      y: 50,
      score: 10
    }
  ],

  --- Actions ---
  actions: [
    %Action{
      uuid: "2130-asdf-12zx-!@z9",
      movement: [
        10, 0    # (x, y) increment
      ],
      shot: []
    },
    %Action{
      uuid: "9a!0-4sRz-#2Zx-P*9P",
      movement: [
        10, 5    # (x, y) increment
      ],
      shot: [
        11, 4    #  (x, y) -> shot vector
      ]
    }
  ]
  """

  defstruct players: [],
            actions: []
end
