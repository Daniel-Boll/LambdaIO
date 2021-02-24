defmodule LambdaIO do
  defdelegate run(), to: LambdaIO.Server
end
