defmodule ZombieApocalypseSurvivalWeb.AuthController do
  use ZombieApocalypseSurvivalWeb, :controller

  alias ZombieApocalypseSurvival.{SurvivorManager, SurvivorManager.Survivor, Auth.Guardian}

  def new(conn, _) do
    changeset = SurvivorManager.change_survivor(%Survivor{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/protected")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.auth_path(conn, :login))
    end
  end

  def login(conn, %{"survivor" => %{"email" => email, "password" => password}} = params) do
    IO.inspect(params)

    SurvivorManager.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  def login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome In ZombieApocalypseSurvival")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/home-page")
  end

  def login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
