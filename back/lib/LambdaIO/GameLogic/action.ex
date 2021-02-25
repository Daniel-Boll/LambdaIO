defmodule LambdaIO.GameLogic.Action do
  def materialize(:shot, action, player, pid_set_state) do

  end

  def materialize(:damage, action, player, pid_set_state) do

  end

  def materialize(:score, action, player, pid_set_state) do

  end

  def materialize(:position, action, player, pid_set_state) do

  end

  def materialize(:create, pid_set_state, player) do
    send(pid_set_state, {:grab, self()})

    receive do
      {:state, state} ->
        send(
          pid_set_state,
          {:update, %{"players"=> [state["players"] |[player]] , "shoots"=>[]}}
        )
    end
  end

end
