defmodule ZombieApocalypseSurvival.ResourceManager.Resource do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZombieApocalypseSurvival.SurvivorManager

  schema "resources" do
    field :quantity, :integer
    field :total_points, :integer

    field :resource_type, Ecto.Enum,
      values: [:fiji_water, :campbell_soup, :first_aid_pouch, :ak47]
      
    belongs_to :survivor, SurvivorManager.Survivor
    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:quantity, :total_points, :resource_type, :survivor_id])
    |> validate_required([:quantity, :total_points, :resource_type])
  end
end
