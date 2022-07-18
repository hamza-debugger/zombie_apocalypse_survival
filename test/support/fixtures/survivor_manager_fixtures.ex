defmodule ZombieApocalypseSurvival.SurvivorManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ZombieApocalypseSurvival.SurvivorManager` context.
  """

  @doc """
  Generate a survivor.
  """
  def survivor_fixture(attrs \\ %{}) do
    {:ok, survivor} =
      attrs
      |> Enum.into(%{
        age: 42,
        gender: "some gender",
        name: "some name",
        password: "some password"
      })
      |> ZombieApocalypseSurvival.SurvivorManager.create_survivor()

    survivor
  end
end
