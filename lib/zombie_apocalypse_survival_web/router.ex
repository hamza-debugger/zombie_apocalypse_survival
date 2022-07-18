defmodule ZombieApocalypseSurvivalWeb.Router do
  use ZombieApocalypseSurvivalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ZombieApocalypseSurvivalWeb.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :static do
    plug Plug.Static,
      at: "/uploads",
      from: "uploads/",
      gzip: false
  end

  scope "/uploads" do
    pipe_through :static

    forward "/",
            Plug.Static,
            at: "/uploads",
            from: "uploads/"
  end

  pipeline :auth do
    plug ZombieApocalypseSurvival.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", ZombieApocalypseSurvivalWeb do
    pipe_through [:browser, :auth]

    get "/", SurvivorController, :new
    post "/signup", SurvivorController, :create
    get "/login", AuthController, :new
    post "/login", AuthController, :login
    get "/logout", AuthController, :logout
  end

  scope "/", ZombieApocalypseSurvivalWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/home-page", SurvivorController, :home_page
    get "/resource", ResourceController, :new
    post "/resource", ResourceController, :create
    get "/resource/:id", ResourceController, :show
    get "/survivor/edit", SurvivorController, :edit
    put "/survivor/update", SurvivorController, :update
    get "/survivors", SurvivorController, :index
    post "/trade/:id", TradeController, :create
    get "/requests", TradeController, :show_requests
    get "/accept-request/:id", TradeController, :accept_request
    get "/reported/:id", ReportController, :get_reported
    get "/report", ReportController, :report_dashboard

  end

  # Other scopes may use custom stacks.
  # scope "/api", ZombieApocalypseSurvivalWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ZombieApocalypseSurvivalWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
