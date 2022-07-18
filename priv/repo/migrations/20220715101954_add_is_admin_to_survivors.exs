defmodule ZombieApocalypseSurvival.Repo.Migrations.AddIsAdminToSurvivors do
  use Ecto.Migration

  def change do
    alter table(:survivors) do
      add :is_admin, :boolean, default: false
    end
  end
end
