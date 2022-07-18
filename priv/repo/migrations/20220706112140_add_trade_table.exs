defmodule ZombieApocalypseSurvival.Repo.Migrations.AddTradeTable do
  use Ecto.Migration

  def up do

    drop_query = "DROP  TYPE IF EXISTS status cascade"
    execute(drop_query)

    create_query = "CREATE TYPE status AS ENUM('cancel', 'reject', 'accept', 'pending')"
    execute(create_query)

    create table(:trades) do

      add :trade_by_id, references(:survivors, on_delete: :delete_all, type: :id)
      add :trade_to_id, references(:survivors, on_delete: :delete_all, type: :id)
      add :by_quantity, :integer, default: 0
      add :by_resource_type, :resource_type
      add :by_total_points, :integer, default: 0
      add :to_quantity, :integer, default: 0
      add :to_resource_type, :resource_type
      add :to_total_points, :integer, default: 0
      add :status, :status
      
      timestamps()
    end
    create index(:trades, [:trade_by_id, :trade_to_id])

  end

  def down do

    drop_query = "DROP  TYPE IF EXISTS status "
    execute(drop_query)

  end

end
