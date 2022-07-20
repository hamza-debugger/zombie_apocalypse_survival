defmodule ZombieApocalypseSurvivalWeb.ReportController do
  use ZombieApocalypseSurvivalWeb, :controller
  alias ZombieApocalypseSurvival.{
    ReportManager,
    SurvivorManager,
    ResourceManager,
    ReportManager.Report,
    Auth.Guardian
  }

  def get_reported(conn, %{"id" => id} = params) do
    id = String.to_integer(id)
    user = Guardian.Plug.current_resource(conn)

    if Bodyguard.permit(ZombieApocalypseSurvival.Policy, :survivor, user, params)  == :ok do

    if !(user.id == id) do
      case ReportManager.get_report_by(id)  do
        [] ->
          ReportManager.create_report(%{report_to_id: user.id, report_by_id: id})
          conn
          |> put_flash(:info, "You reported this user successfully.")
          |> redirect(to: Routes.survivor_path(conn, :new))

          reprted_user -> if Enum.count(reprted_user) >=  5 do
                            case SurvivorManager.get_survivor!(id) do
                             nil ->  conn
                                     |> put_flash(:info, "You are reported infected.")
                                     |> redirect(to: "/logout")
                             survivor ->
                                          SurvivorManager.update_survivor(survivor, %{survivor_flag: true})
                                          conn
                                          |> put_flash(:info, "You are reported infected.")
                                          |> redirect(to: "/logout")

                            end

                        else
                          ReportManager.create_report(%{report_to_id: user.id, report_by_id: id})
                          conn
                          |> put_flash(:info, "You reported this user successfully.")
                          |> redirect(to: Routes.survivor_path(conn, :new))
                        end
      end

    else
      conn
      |> put_flash(:info, "You can't report yourself.")
      |> redirect(to: Routes.survivor_path(conn, :new))


    end

  else
    conn
    |> put_status(:forbidden)
    |> put_view(ZombieApocalypseSurvivalWeb.ErrorView)
    |> render(:"403")

  end

end


def report_dashboard(conn, params) do
    user = Guardian.Plug.current_resource(conn)
   if Bodyguard.permit(ZombieApocalypseSurvival.Policy, :admin, user, params) |> IO.inspect(label: "Bodyguard") == :ok do

      infacted = average(SurvivorManager.infacted_survivor, SurvivorManager.survivor_count)
      non_infacted = average(SurvivorManager.non_infacted_survivor, SurvivorManager.survivor_count)
      fiji = average(ResourceManager.sum_of_quantity("fiji_water"), ResourceManager.resource_count("fiji_water"))
      soup = average(ResourceManager.sum_of_quantity("campbell_soup"), ResourceManager.resource_count("campbell_soup"))
      pouch = average(ResourceManager.sum_of_quantity("first_aid_pouch"), ResourceManager.resource_count("first_aid_pouch"))
      ak47 = average(ResourceManager.sum_of_quantity("ak47"), ResourceManager.resource_count("fiji_water"))

      survivor = %{infacted: infacted, non_infacted: non_infacted, fiji: fiji, soup: soup, pouch: pouch, ak47: ak47}
      IO.inspect(survivor, label: "Report Dashboard")
      render(conn, "report_dashboard.html", survivor: survivor)

   else
    conn
    |> put_flash(:info, "You Are Not a Admin Broo.")
    |> redirect(to: Routes.survivor_path(conn, :home_page))

  end

end

def average(value, total) do
  if total == 0 do
    1
  else
    (value/total)|>ceil()
  end
end


end
