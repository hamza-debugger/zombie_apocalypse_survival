defmodule ZombieApocalypseSurvival.ResourceManager do
  @moduledoc """
  The resourceManager context.
  """

  import Ecto.Query, warn: false
  alias ZombieApocalypseSurvival.Repo
  alias Argon2
  alias ZombieApocalypseSurvival.ResourceManager.Resource

  @doc """
  Returns the list of resources.

  ## Examples

      iex> list_resources()
      [%Resource{}, ...]

  """
  def list_resource do
    Repo.all(Resource)
  end

  @doc """
  Gets a single Resource.

  Raises `Ecto.NoResultsError` if the Resource does not exist.

  ## Examples

      iex> get_resource!(123)
      %Resource{}

      iex> get_resource!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resource!(id),
    do: Repo.get!(Resource, id) |> IO.inspect(label: "Get Resource===========")

  @doc """
  Creates a Resource.

  ## Examples

      iex> create_resource(%{field: value})
      {:ok, %Resource{}}

      iex> create_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Resource.

  ## Examples

      iex> update_resource(Resource, %{field: new_value})
      {:ok, %Resource{}}

      iex> update_resource(Resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Resource.

  ## Examples

      iex> delete_resource(Resource)
      {:ok, %Resource{}}

      iex> delete_resource(Resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resource(%Resource{} = resource) do
    Repo.delete(resource)
  end

  def get_resource_by_resource_type(resource_type, survivor_id) do
    Resource
    |> where([r], r.survivor_id == ^survivor_id and r.resource_type == ^resource_type)
    |> Repo.one()
  end


  def resource_count(resource_type) do
    Resource
    |> where([r], r.resource_type == ^resource_type)
    |> select([r], count(r.id))
    |> Repo.one
  end

  def sum_of_quantity(resource_type) do
    Resource
    |> where([r], r.resource_type == ^resource_type)
    |> select([r], sum(r.quantity))
    |> Repo.one
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Resource changes.

  ## Examples

      iex> change_resource(Resource)
      %Ecto.Changeset{data: %Resource{}}

  """
  def change_resource(%Resource{} = resource, attrs \\ %{}) do
    Resource.changeset(resource, attrs)
  end

  def get_resources_by_survivor_id(survivor_id) do
    Resource
    |> where([r], r.survivor_id == ^survivor_id)
    |> Repo.all()
  end
end
