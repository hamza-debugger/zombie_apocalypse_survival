defmodule ZombieApocalypseSurvival.Repo.Migrations.AddResourcesTable do
  use Ecto.Migration

  def up do

    drop_query = "DROP  TYPE IF EXISTS resource_type cascade"
    execute(drop_query)

    create_query = "CREATE TYPE resource_type AS ENUM('fiji_water', 'campbell_soup', 'first_aid_pouch', 'ak47')"
    execute(create_query)

    create table(:resources) do

      add :quantity, :integer, default: 0
      add :resource_type, :resource_type
      add :total_points, :integer, default: 0
      add :survivor_id, references(:survivors, on_delete: :delete_all, type: :id)
      timestamps()
    end
    create index(:resources, [:survivor_id])

  end

  def down do

    drop_query = "DROP  TYPE IF EXISTS resource_type "
    execute(drop_query)

  end



end
