defmodule ZombieApocalypseSurvival.Policy do
  @moduledoc """
  The policy context.
  """

  @behaviour Bodyguard.Policy

  def authorize(:admin, user, _product), do: user.is_admin

   # Regular users can create posts
   def authorize(:survivor, %{is_admin: false}, _), do: true

   # Catch-all: deny everything else
   def authorize(_, _, _), do: false

end
