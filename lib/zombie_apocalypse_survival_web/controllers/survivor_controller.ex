defmodule ZombieApocalypseSurvivalWeb.SurvivorController do
  use ZombieApocalypseSurvivalWeb, :controller
  alias ZombieApocalypseSurvivalWeb.AuthController

  alias ZombieApocalypseSurvival.{
    SurvivorManager,
    SurvivorManager.Survivor,
    Auth.Guardian,
    Avatar,
    Survivor_loc_log
  }


  def home_page(conn, _params) do
    render(conn, "home_page.html")
  end

  def new(conn, _params) do
    changeset = SurvivorManager.change_survivor(%Survivor{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/resource")
    else
      render(conn, "signup.html",
        changeset: changeset,
        action: Routes.survivor_path(conn, :create)
      )
    end
  end

  def create(conn, %{"survivor" => %{"profile_photo" => %{filename: filename}, "email" => email} = params}) do
    #  %{"profile_photo" => %{filename: filename}} = params
    case SurvivorManager.get_survivor_by_email(email) do
     nil ->
          params =
              params
              |> Map.put("profile_image", filename)

            case SurvivorManager.create_survivor(params) do
              {:ok, %Survivor{} = survivor} ->
                create_location_log(%{
                  survivor_id: survivor.id,
                  latitude: params["latitude"],
                  longitude: params["longitude"]
                })

                profile_photo_upload(params, survivor)
                AuthController.login_reply({:ok, survivor}, conn)

              {:error, changeset} ->
                IO.inspect(changeset)
                conn
                |> put_flash(:error, "Some Thing Went Wrong")
                |> new(%{})
            end
     _survivor ->
        conn
        |> put_flash(:error, "Email Already Registered")
        |> new(%{})

     end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "All Fields Are Required")
    |> new(%{})
  end

  def create_location_log(params) do
    Survivor_loc_log.create_survivor_loc_log(params)
  end

  def profile_photo_upload(params, survivor) do
    %{"profile_photo" => upload_plug} = params
    Avatar.store({upload_plug, survivor})
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    if Bodyguard.permit(ZombieApocalypseSurvival.Policy, :survivor, user) |> IO.inspect(label: "Bodyguard") == :ok do
      IO.inspect("=====Index========")
      render(conn, "all_survivors.html", survivors: list_survivors())
    else
    conn
    |> put_status(:forbidden)
    |> put_view(ZombieApocalypseSurvivalWeb.ErrorView)
    |> render(:"403")

    end

  end

  defp list_survivors do
    SurvivorManager.list_survivors()
    |> IO.inspect(label: "list_survivors")
  end

  def edit(conn, _params) do
    survivor = Guardian.Plug.current_resource(conn)
    changeset = SurvivorManager.change_survivor(survivor)
    image = Avatar.url({survivor.profile_image, survivor}, :thumb)

    render(conn, "update_survivor.html",
      survivor: survivor,
      image: image,
      changeset: changeset,
      action: Routes.survivor_path(conn, :update)
    )
  end

  def update(conn, %{"survivor" => %{"profile_photo_" => _image} = survivor_params}) do
    survivor = Guardian.Plug.current_resource(conn)
    profile_photo_upload(survivor_params, survivor)

    case SurvivorManager.update_survivor(survivor, survivor_params) do
      {:ok, _survivor} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.survivor_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "update_survivor.html", survivor: survivor, changeset: changeset)
    end
  end

  def update(conn, %{
        "survivor" => %{"latitude" => _latitude, "longitude" => _longitude} = survivor_params
      }) do
    survivor = Guardian.Plug.current_resource(conn)

    case SurvivorManager.update_survivor(survivor, survivor_params) do
      {:ok, _survivor} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.survivor_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "update_survivor.html", survivor: survivor, changeset: changeset)
    end
  end

end