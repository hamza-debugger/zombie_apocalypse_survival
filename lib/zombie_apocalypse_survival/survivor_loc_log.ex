defmodule ZombieApocalypseSurvival.Survivor_loc_log do
  @moduledoc """
  The Survivor_loc_log context.
  """

  import Ecto.Query, warn: false
  alias ZombieApocalypseSurvival.Repo
  alias Argon2
  alias ZombieApocalypseSurvival.SurvivorManager.SurvivorLocLog

  @doc """
  Returns the list of survivor_loc_logs.

  ## Examples

      iex> list_survivor_loc_logs()
      [%Survivor_loc_log{}, ...]

  """
  def list_survivor_loc_log do
    Repo.all(SurvivorLocLog)
  end

  @doc """
  Gets a single Survivor_loc_log.

  Raises `Ecto.NoResultsError` if the Survivor_loc_log does not exist.

  ## Examples

      iex> get_survivor_loc_log!(123)
      %Survivor_loc_log{}

      iex> get_survivor_loc_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survivor_loc_log!(id), do: Repo.get!(SurvivorLocLog, id)

  @doc """
  Creates a Survivor_loc_log.

  ## Examples

      iex> create_survivor_loc_log(%{field: value})
      {:ok, %Survivor_loc_log{}}

      iex> create_survivor_loc_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survivor_loc_log(attrs \\ %{}) do
    %SurvivorLocLog{}
    |> SurvivorLocLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Survivor_loc_log.

  ## Examples

      iex> update_survivor_loc_log(Survivor_loc_log, %{field: new_value})
      {:ok, %Survivor_loc_log{}}

      iex> update_survivor_loc_log(Survivor_loc_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survivor_loc_log(%SurvivorLocLog{} = survivor_loc_log, attrs) do
    survivor_loc_log
    |> SurvivorLocLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Survivor_loc_log.

  ## Examples

      iex> delete_survivor_loc_log(Survivor_loc_log)
      {:ok, %Survivor_loc_log{}}

      iex> delete_survivor_loc_log(Survivor_loc_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survivor_loc_log(%SurvivorLocLog{} = survivor_loc_log) do
    Repo.delete(survivor_loc_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Survivor_loc_log changes.

  ## Examples

      iex> change_survivor_loc_log(Survivor_loc_log)
      %Ecto.Changeset{data: %Survivor_loc_log{}}

  """
  def change_survivor_loc_log(%SurvivorLocLog{} = survivor_loc_log, attrs \\ %{}) do
    SurvivorLocLog.changeset(survivor_loc_log, attrs)
  end
end
