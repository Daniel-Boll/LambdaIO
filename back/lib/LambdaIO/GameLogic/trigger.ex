defmodule LambdaIO.GameLogic.Trigger do
  alias LambdaIO.GameLogic.Action

  @moduledoc """
    --- Player's state --- \n
    players: [ \n
      %Player{
        uuid: "hash",
        x: number,
        y: number,
        score: number,
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

        Enum.map(player["actions"]["shot"], fn shot ->
          Action.materialize(:shot, shot, player["uuid"], pid_set_state)
        end)

        # For the damage
        Action.materialize(:damage, player["actions"]["damage"], player["uuid"], pid_set_state)
    end
  end

  def instantiate(key, pid_set_state) do
    Action.materialize(:create, pid_set_state,
      %{
        "x" => 50,
        "y" => 50,
        "score" => 0,
        "health" => 100,
        "uuid" => key,
      })
  end
end
