# Declares the types for a cell
defmodule Cell do
  @derive Jason.Encoder

  @type id :: String.t()

  @type location :: %{:x => integer, :y => integer}

  @type uncovered :: boolean

  @type bomb :: boolean

  @type value :: integer()

  defstruct id: 0, location: %{:x => 0, :y => 0}, uncovered: false, bomb: false, value: 0
end
