defmodule ZombieApocalypseSurvival.SurvivorManager do
  @moduledoc """
  The SurvivorManager context.
  """

  import Ecto.Query, warn: false
  alias ZombieApocalypseSurvival.Repo
  alias Argon2
  alias ZombieApocalypseSurvival.SurvivorManager.Survivor





  defdelegate authorize(action, user, params), to: ZombieApocalypseSurvival.Policy

  @doc """
  Returns the list of survivors.

  ## Examples

      iex> list_survivors()
      [%Survivor{}, ...]

  """
  def list_survivors do
    Survivor
    |> where([s], s.survivor_flag == false)
    |> Repo.all()
  end



  def trade_with_resource(resource_type, id) do
    Trade
    |> where([t], t.trade_to_id == ^id and t.to_resource_type == ^resource_type)
    |> Repo.one()
end
  @doc """
  Gets a single survivor.

  Raises `Ecto.NoResultsError` if the Survivor does not exist.

  ## Examples

      iex> get_survivor!(123)
      %Survivor{}

      iex> get_survivor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survivor!(id), do: Repo.get!(Survivor, id) |> Repo.preload([:resource])

  def get_survivor_by_email(email) do
    Survivor
    |> where([s], s.email == ^email)
    |> Repo.one
  end

  @doc """
  Creates a survivor.

  ## Examples

      iex> create_survivor(%{field: value})
      {:ok, %Survivor{}}

      iex> create_survivor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survivor(attrs \\ %{}) do
    %Survivor{}
    |> Survivor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survivor.

  ## Examples

      iex> update_survivor(survivor, %{field: new_value})
      {:ok, %Survivor{}}

      iex> update_survivor(survivor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survivor(%Survivor{} = survivor, attrs) do
    survivor
    |> Survivor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survivor.

  ## Examples

      iex> delete_survivor(survivor)
      {:ok, %Survivor{}}

      iex> delete_survivor(survivor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survivor(%Survivor{} = survivor) do
    Repo.delete(survivor)
  end

  def survivor_count() do
    Survivor
    |> select([s], count(s.id))
    |> Repo.one
  end

  def infacted_survivor() do
    Survivor
    |> where([s], s.survivor_flag == true)
    |> select([s], count(s.id))
    |> Repo.one
  end

  def non_infacted_survivor() do
    Survivor
    |> where([s], s.survivor_flag == false)
    |> select([s], count(s.id))
    |> Repo.one
  end



  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survivor changes.

  ## Examples

      iex> change_survivor(survivor)
      %Ecto.Changeset{data: %Survivor{}}

  """
  def change_survivor(%Survivor{} = survivor, attrs \\ %{}) do
    Survivor.changeset(survivor, attrs)
  end

  def authenticate_user(email, plain_text_password) do
    query = from u in Survivor, where: u.email == ^email and u.survivor_flag == false

    case Repo.one(query) do
      nil ->

        Argon2.no_user_verify()
        {:error, "Invalid credentials or May be you are infacted"}

      user ->
        if Argon2.verify_pass(plain_text_password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
