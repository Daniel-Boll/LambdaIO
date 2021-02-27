defmodule LambdaIO.GameLogic.Trigger do
  alias LambdaIO.GameLogic.Action

  @moduledoc """
    --- Player's state --- \n
    players: [ \n
      %Player{
        uuid: "hash",
        position:{
          x: number,
          y: number,
        },
        score: number,
        health: number,
        action: %Action{
          shoot: [[number(x), number(y), number(xt), number(yt)]],
          damage: number,
        }
      },
    ],
  """
  def evaluate(pid_set_state \\ 0) do
    receive do
      {:trigger, player} ->
        # For the shot
        # IO.inspect(player)
        Enum.map(
          player["shoot"], # Change the hole fuck to shot
          fn shot ->
            Action.materialize(:shot, shot, player["uuid"], pid_set_state)
          end
        )

        # IO.inspect(player)

        # For the position
        Action.materialize(:position, player["position"], player["uuid"], pid_set_state)

        # For the score
        Action.materialize(:score, player["score"], player["uuid"], pid_set_state)

        # For the heath
        Action.materialize(:health, player["health"], player["uuid"], pid_set_state)

        evaluate(pid_set_state)
    end
  end

  def instantiate(key, pid_set_state) do
    Action.materialize(:create, pid_set_state,
      %{
        "position" => %{
          "x" => 400,
          "y" => 300
        },
        "score" => 0,
        "health" => 100,
        "uuid" => key,
      })
  end
end
