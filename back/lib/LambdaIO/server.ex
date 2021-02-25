defmodule LambdaIO.Server do

  @doc """
    First function to be called
      <> no params
      <> spawn the set_state loop
      <> spawn the socket_loop.
  """
  def run() do
    server = Socket.Web.listen! 3001

    pid_set_state  = spawn(LambdaIO.Server, :set_state, [%{"players"=> [], "shoots"=>[]}])
    pid_gl_trigger = spawn(LambdaIO.GameLogic.Trigger, :evaluate, [pid_set_state])

    spawn(fn -> socket_loop(server, pid_set_state, pid_gl_trigger) end)
    :ok
  end

  @doc """
    ...
  """
  def set_state(state \\ 0) do
    receive do
      {:update, new_state} ->
        set_state(new_state)

      {:grab, pid_emmiter} ->
        send(pid_emmiter, {:state, state})
        set_state(state)
    end
  end

  def socket_loop(server, pid_set_state, pid_gl_trigger) do
    client = server |> Socket.Web.accept!
    client |> Socket.Web.accept!

    client |> Socket.Web.send!({:text, client.key})
    # Take the client.key to be
    # the uuid
    spawn(fn -> client_emmiter(client, pid_set_state) end)
    spawn(LambdaIO.GameLogic.Trigger, :instantiate, [client.key, pid_set_state])
    spawn(fn -> client_receiver(client, pid_gl_trigger) end)
    socket_loop(server, pid_set_state, pid_gl_trigger)
  end

  def client_receiver(client, pid_gl_trigger) do
    {:text, json} = client |> Socket.Web.recv!
    {:ok, player} = JSON.decode(json)

    send(pid_gl_trigger, {:trigger, player})

    client_receiver(client, pid_gl_trigger )
  end

  # TODO: Restrict sockets per second
  def client_emmiter(client, pid_set_state) do
    send(pid_set_state, {:grab, self()})
    receive do
      {:state, state} ->
        {:ok, result} = JSON.encode(state)
        client |> Socket.Web.send!({:text, result})

        client_emmiter(client, pid_set_state)
    end
  end

end
