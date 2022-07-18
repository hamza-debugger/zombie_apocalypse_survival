defmodule ZombieApocalypseSurvival.Repo.Migrations.AddReportTable do
  use Ecto.Migration

  def change do
    create table(:reports) do

      add :report_by_id, references(:survivors, on_delete: :delete_all, type: :id)
      add :report_to_id, references(:survivors, on_delete: :delete_all, type: :id)

      timestamps()
    end
    create index(:reports, [:report_by_id, :report_to_id])
  end
end
