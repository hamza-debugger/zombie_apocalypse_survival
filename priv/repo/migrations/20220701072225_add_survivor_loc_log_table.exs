defmodule ZombieApocalypseSurvival.Repo.Migrations.AddSurvivorLocLogTable do
  use Ecto.Migration

  def change do

    create table(:survivors_loc_log) do
    add :survivor_id, references(:survivors, on_delete: :delete_all,type: :id)
    add :latitude, :float
    add :longitude, :float
    timestamps()
    end
    create index(:survivors_loc_log, [:survivor_id])
  end

end
