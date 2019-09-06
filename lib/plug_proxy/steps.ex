defmodule PlugProxy.Steps do
  def execute(conn, command, args) do
    functor_args = args ++ [conn.processors.state]
    functor = Map.get(conn.processors, command)
    # the response may be { content, state } or
    # { content, state, conn }.  This allows sharing the connection
    # and altering it in the functor.
    functor_response = apply( functor, functor_args )
    { content, state, conn } =
      case functor_response do
        { content, state } -> { content, state, conn }
        { content, state, conn } -> { content, state, conn }
      end

    processors = Map.put(conn.processors, :state, state)
    conn = Map.put(conn, :processors, processors)

    { content, conn }
  end
end
