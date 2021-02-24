defmodule LambdaIO.Server do
  def run() do
    server = Socket.Web.listen! 3001
    state_process = spawn(LambdaIO.Server, :set_state, [])
    spawn(fn -> loop_socket(server, state_process) end)
    :ok
  end

  def set_state(state \\ 0) do
    receive do
      {:ok, {pid, value}} ->
        send(pid, {:state, [state|value]})
        set_state([state|value])

      {_, value} ->
        IO.puts "without: #{value}"
    end
  end

  def loop_socket(server, p_state) do
    client = server |> Socket.Web.accept!
    client |> Socket.Web.accept!

    client |> Socket.Web.send!({:text, "Funcionando"})
    # Take the client.key to be
    # the uuid
    spawn(fn -> loop_socket(server, p_state) end)
    loop(client, p_state)
  end

  def loop(client, p_state) do
    {:text, value} = client |> Socket.Web.recv!

    # IO.inspect(client)
    # IO.inspect(JSON.decode(value))

    send(p_state, {:ok, {self(), value}})

    receive do
      {:state, state} ->
        client |> Socket.Web.send!({:text, "#{state}"})
    end

    loop(client, p_state)
  end
end
