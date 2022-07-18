defmodule ZombieApocalypseSurvival.SurvivorManager.SurvivorLocLog do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZombieApocalypseSurvival.SurvivorManager

  schema "survivors_loc_log" do
    field :latitude, :float
    field :longitude, :float
    belongs_to :survivor, SurvivorManager.Survivor
    timestamps()
  end

  @doc false
  def changeset(survivor_loc_log, attrs) do
    survivor_loc_log
    |> cast(attrs, [:latitude, :longitude, :survivor_id])
    |> validate_required([:latitude, :longitude])
  end
end
