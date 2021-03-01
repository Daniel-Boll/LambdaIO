defmodule LambdaIO.GameLogic.Action do

  # Generate random id for shoot
  def gen_reference() do
    min = String.to_integer("100000", 36)
    max = String.to_integer("ZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end

  def materialize(:shot, shot, player, pid_set_state) do
    send(pid_set_state, {:grab, self()})
    receive do
      {:state, state} ->

        otherShots = state

        send(
          pid_set_state,
          {:update, %{ state | "shoot" => [  [shot] | otherShots ]}}
        )
    end
  end

  def materialize(:health, damage, player, pid_set_state) do
    send(pid_set_state, {:grab, self()})
    receive do
      {:state, state} ->
        [currentPlayer] = Enum.filter(state["players"], fn p -> p["uuid"] == player end)
        otherPlayers = Enum.filter(state["players"], fn p -> p["uuid"] != player end)

        updatedHealth = currentPlayer["health"]
        updatedPlayer = %{currentPlayer | "health"=> updatedHealth }

        send(
          pid_set_state,
          {:update, %{ state | "players"=> [  updatedPlayer | otherPlayers ] }}
        )
    end
  end

  def materialize(:score, score, player, pid_set_state) do
    send(pid_set_state, {:grab, self()})
    receive do
      {:state, state} ->
        [currentPlayer] = Enum.filter(state["players"], fn p -> p["uuid"] == player end)
        otherPlayers = Enum.filter(state["players"], fn p -> p["uuid"] != player end)

        updatedPlayer = %{currentPlayer | "score"=> score }

        send(
          pid_set_state,
          {:update, %{ state | "players"=> [  updatedPlayer | otherPlayers ]}}
        )
    end
  end

  def materialize(:position, position, player, pid_set_state) do
    send(pid_set_state, {:grab, self()})
    receive do
      {:state, state} ->

        [currentPlayer] = Enum.filter(state["players"], fn p -> p["uuid"] == player end)
        otherPlayers = Enum.filter(state["players"], fn p -> p["uuid"] != player end)

        updatedPlayer = %{currentPlayer | "position" => position}

        # IO.inspect([ updatedPlayer | otherPlayers ])

        send(
          pid_set_state,
          {:update, %{ state | "players" => [  updatedPlayer | otherPlayers ]}}
        )
    end
  end

  def materialize(:create, pid_set_state, player) do
    send(pid_set_state, {:grab, self()})

    receive do
      {:state, state} ->
        # IO.inspect(state)
        send(
          pid_set_state,
          {:update, %{ state | "players" => [player| state["players"]]}}
        )
    end
  end

end
