defmodule ZombieApocalypseSurvival.ReportManager.Report do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZombieApocalypseSurvival.SurvivorManager

  schema "reports" do
    
    belongs_to :report_to, SurvivorManager.Survivor
    belongs_to :report_by, SurvivorManager.Survivor
    timestamps()

  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [:report_by_id, :report_to_id])
  end
end
