defmodule ZombieApocalypseSurvival.SurvivorManager.Survivor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Argon2
  alias ZombieApocalypseSurvival.{ResourceManager, SurvivorManager}
  use  Waffle.Ecto.Schema

  schema "survivors" do
    field :age, :integer
    field :gender, :string
    field :name, :string
    field :password, :string
    field :email, :string
    field :survivor_flag, :boolean
    field :latitude, :float
    field :longitude, :float
    field :profile_image, ZombieApocalypseSurvival.Avatar.Type
    field :is_admin, :boolean
    has_many :resource, ResourceManager.Resource
    has_many :survivor_loc_log, SurvivorManager.SurvivorLocLog
    timestamps()
  end

  @doc false
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, [
      :name,
      :password,
      :age,
      :gender,
      :email,
      :latitude,
      :longitude,
      :survivor_flag,
      :is_admin,
      # :profile_image
    ])
    |> cast_attachments(attrs, [:profile_image])
    |> validate_required([
      :name,
      :password,
      :age,
      :gender,
      :email,
      :latitude,
      :longitude,
    ])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
