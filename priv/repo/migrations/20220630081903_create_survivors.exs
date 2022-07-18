defmodule ZombieApocalypseSurvival.Repo.Migrations.CreateSurvivors do
  use Ecto.Migration

  def change do
    create table(:survivors) do
      add :name, :string
      add :password, :string
      add :email, :string
      add :age, :integer
      add :gender, :string
      add :latitude, :float
      add :longitude, :float
      add :profile_image, :string
      add :survivor_flag, :boolean, default: false, null: false

      timestamps()
    end
    create unique_index(:survivors, [:email])
    create index(:survivors, :survivor_flag)
  end
end
