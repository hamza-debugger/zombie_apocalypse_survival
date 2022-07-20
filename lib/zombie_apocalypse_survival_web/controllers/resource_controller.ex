defmodule ZombieApocalypseSurvivalWeb.ResourceController do
  use ZombieApocalypseSurvivalWeb, :controller
  # alias ZombieApocalypseSurvivalWeb.AuthController
  alias ZombieApocalypseSurvival.{
    ResourceManager,
    SurvivorManager,
    ResourceManager.Resource,
    Auth.Guardian
  }

  def new(conn, _params) do
    changeset = ResourceManager.change_resource(%Resource{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      case ResourceManager.get_resources_by_survivor_id(maybe_user.id) do
        [] ->
          render(conn, "new_resource.html",
            changeset: changeset,
            action: Routes.resource_path(conn, :create)
          )

        _resources ->
          redirect(conn, to: "/survivors")
      end
    else
      redirect(conn, to: "/signup")
    end
  end

  def create(conn, %{"resource" => resources} = _params) do
    current_resource = Guardian.Plug.current_resource(conn)
    IO.inspect(current_resource, label: "bro")

    Enum.reduce(resources, %{}, fn resource, _acc ->

      case resource do
        {"ak47", quantity} ->
          %{
            survivor_id: current_resource.id,
            resource_type: "ak47",
            quantity: quantity,
            total_points: String.to_integer(quantity) * 8
          }

        {"campbell_soup", quantity} ->
          %{
            survivor_id: current_resource.id,
            resource_type: "campbell_soup",
            quantity: quantity,
            total_points: String.to_integer(quantity) * 12
          }

        {"fiji_water", quantity} ->
          %{
            survivor_id: current_resource.id,
            resource_type: "fiji_water",
            quantity: quantity,
            total_points: String.to_integer(quantity) * 14
          }

        {"first_aid_pouch", quantity} ->
          %{
            survivor_id: current_resource.id,
            resource_type: "first_aid_pouch",
            quantity: quantity,
            total_points: String.to_integer(quantity) * 10
          }

        _ ->
          %{}
      end
      |> ResourceManager.create_resource()
    end)

    redirect(conn, to: "/survivors")
  end

  def show(conn, %{"id" => id}) do
    survivor = SurvivorManager.get_survivor!(id)
    current_survivor = current_resource_with_resources(conn)
    changeset = ResourceManager.change_resource(%Resource{})
    render(conn, "show_resource.html", survivor: survivor, current_survivor: current_survivor, changeset: changeset, action: Routes.trade_path(conn, :create, survivor) )
  end

  defp current_resource_with_resources(conn) do
    current_resource = Guardian.Plug.current_resource(conn)
    SurvivorManager.get_survivor!(current_resource.id)
  end

end
