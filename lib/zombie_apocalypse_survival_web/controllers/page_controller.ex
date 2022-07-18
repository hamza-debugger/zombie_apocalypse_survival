defmodule ZombieApocalypseSurvivalWeb.PageController do
  use ZombieApocalypseSurvivalWeb, :controller

  def index(conn, _params) do
    render(conn, "signup.html")
  end

  def protected(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "protected.html", current_user: user)
  end
end
