defmodule LambdaIO.Server do

  @doc """
    First function to be called
      <> no params
      <> spawn the set_state loop
      <> spawn the socket_loop.
  """
  def run() do
    server = Socket.Web.listen! 3001

    pid_set_state  = spawn(LambdaIO.Server, :set_state, [%{"players" => [], "shoots"=>[]}])
    pid_gl_trigger = spawn(LambdaIO.GameLogic.Trigger, :evaluate, [pid_set_state])

    pid_socket_sent_restriction = spawn(LambdaIO.Server, :socket_sent_restriction, [])
    pid_schedule_socket = spawn(LambdaIO.Server, :schedule_socket, [])

    spawn(fn -> socket_loop(server, pid_set_state, pid_gl_trigger, pid_socket_sent_restriction, pid_schedule_socket) end)
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

  def socket_loop(server, pid_set_state, pid_gl_trigger, pid_socket_sent_restriction, pid_schedule_socket) do
    client = server |> Socket.Web.accept!
    client |> Socket.Web.accept!

    IO.puts("Novo client acessou")
    IO.inspect(client.key)

    client |> Socket.Web.send!({:text, client.key})

    pid_client_emmiter = spawn(fn -> client_emmiter(client, pid_set_state) end)
    spawn(LambdaIO.GameLogic.Trigger, :instantiate, [client.key, pid_set_state])
    spawn(fn -> client_receiver(client, pid_gl_trigger) end)
    spawn(fn -> client_emmiter2(client, pid_gl_trigger) end)


    # send(pid_schedule_socket, {:send, {pid_socket_sent_restriction, pid_client_emmiter, pid_set_state}})
    socket_loop(server, pid_set_state, pid_gl_trigger, pid_socket_sent_restriction, pid_schedule_socket)
  end

  def client_receiver(client, pid_gl_trigger) do
    if client do
      case client |> Socket.Web.recv! do
        {:text, json} ->
          {:ok, player} = JSON.decode(json)

          send(pid_gl_trigger, {:trigger, player})

          client_receiver(client, pid_gl_trigger)

        {:close, :going_away, ""} ->
          IO.puts ("Encerrado! Fechado com Bolsonaro")
      end
    end
  end

  # TODO: Restrict sockets per second
  def client_emmiter(client, pid_set_state) do
    receive do
      {:state, state} ->
        {:ok, result} = JSON.encode(state)

        client |> Socket.Web.send!({:text, result})

        client_emmiter(client, pid_set_state)
    end
  end

  def client_emmiter2(client, pid_set_state) do
    :timer.sleep(Kernel.trunc(1000 / 60))
    send(pid_set_state, {:grab, pid_set_state})
    receive do
      {:state, state} ->
        {:ok, result} = JSON.encode(state)

        client |> Socket.Web.send!({:text, result})

        client_emmiter(client, pid_set_state)
    end
  end

  def grab_state(n, pid_set_state, pid_client_emmiter) do
    send(pid_set_state, {:grab, pid_client_emmiter})
    :timer.sleep(Kernel.trunc(1000 / n))
    grab_state(n, pid_set_state, pid_client_emmiter)
  end

  def socket_sent_restriction() do
    receive do
      {:context, pid_schedule_socket, pid_client_emmiter, pid_set_state, n} ->
        grab_state(n, pid_set_state, pid_client_emmiter)

        send(
          pid_schedule_socket,
          {
            :send,
            {self(), pid_client_emmiter, pid_set_state}
          })
        socket_sent_restriction()
    end
  end

  def schedule_socket() do
    receive do
      {:send, {pid_socket_sent_restriction, pid_client_emmiter, pid_set_state}} ->
        Process.send_after(
          pid_socket_sent_restriction,
          {:context, self(),pid_client_emmiter, pid_set_state, 60},
          1000
        )
        schedule_socket()
    end
  end
end
