defmodule ZombieApocalypseSurvival.TradeManager.Trade do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZombieApocalypseSurvival.SurvivorManager

  schema "trades" do

    field :by_quantity, :integer, default: 0
    field :by_resource_type, Ecto.Enum, values: [:fiji_water, :campbell_soup, :first_aid_pouch, :ak47]
    field :by_total_points, :integer, default: 0
    field :to_quantity, :integer, default: 0
    field :to_resource_type, Ecto.Enum, values: [:fiji_water, :campbell_soup, :first_aid_pouch, :ak47]
    field :to_total_points, :integer, default: 0
    field :status, Ecto.Enum, values: [:cancel, :reject, :accept, :pending]
    
    belongs_to :trade_to, SurvivorManager.Survivor
    belongs_to :trade_by, SurvivorManager.Survivor
    timestamps()

  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [:by_quantity, :by_total_points, :by_resource_type, :trade_by_id, :to_quantity, :to_total_points, :to_resource_type, :trade_to_id, :status])
    |> validate_required([:by_quantity, :by_total_points, :by_resource_type, :to_quantity, :to_total_points, :to_resource_type, :status])
  end
end
